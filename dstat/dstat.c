/* $Id: dstat.c 40 2019-01-01 00:30:07Z umaxx $
 * Copyright (c) 2016-2019 Joerg Jung <jung@openbsd.org>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */
#include <X11/Xatom.h>
#include <X11/Xlib.h>
#include <X11/Xos.h>
#include <X11/Xutil.h>
#include <err.h>
#include <errno.h>
#include <fcntl.h>
#include <ifaddrs.h>
#include <limits.h>
#include <machine/apmvar.h>
#include <net/if.h>
#include <net/if_media.h>
#include <net80211/ieee80211.h>
#include <net80211/ieee80211_ioctl.h>
#include <stdarg.h>
#include <stdio.h>
#include <string.h>
#include <sys/audioio.h>
#include <sys/ioctl.h>
#include <sys/param.h>
#include <sys/resource.h>
#include <sys/sched.h>
#include <sys/sensors.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <sys/types.h>
#include <time.h>
#include <unistd.h>
#include <util.h>

#define D_V "0.6"
#define D_YR "2015-2021"
#define D_BUF 64

#define d_warn(s) (warn(s), s)

static const char *d_bar(unsigned char p) {
  const char *s[] = {"▁", "▂", "▃", "▄", "▅", "▆", "▇", "█", "█"};

  return s[((8 * p) / 100)];
}

static const char *d_dots(unsigned char q) {
  const char *s[] = {"  ", " .", "..", ".:", "::"};

  return s[((4 * q) / 100)];
}

static char *d_fmt(char *s, size_t sz, const char *fmt, ...) {
  va_list va;
  int r;

  va_start(va, fmt), r = vsnprintf(s, sz, fmt, va), va_end(va);
  if (r < 0 || (size_t)r >= sz)
    return d_warn("vsnprintf failed");
  return s;
}

static char *d_wifi(const char *ifn) {
  static char s[D_BUF];
  struct ieee80211_bssid bssid;
  struct ieee80211_nodereq nr;
  int fd, q;

  memset(&bssid, 0, sizeof(bssid)), memset(&nr, 0, sizeof(nr));
  if ((fd = socket(AF_INET, SOCK_DGRAM, 0)) == -1)
    return d_warn("socket failed");
  d_fmt(bssid.i_name, sizeof(bssid.i_name), "%s", ifn);
  if ((ioctl(fd, SIOCG80211BSSID, &bssid)) == -1)
    return close(fd), (errno == ENOTTY ? "" : d_warn("ioctl failed"));
  d_fmt(nr.nr_ifname, sizeof(nr.nr_ifname), "%s", ifn);
  memmove(&nr.nr_macaddr, bssid.i_bssid, sizeof(nr.nr_macaddr));
  if ((ioctl(fd, SIOCG80211NODE, &nr)) == -1 && nr.nr_rssi)
    return close(fd), d_warn("ioctl failed");
  if (nr.nr_max_rssi)
    q = IEEE80211_NODEREQ_RSSI(&nr);
  else
    q = nr.nr_rssi >= -50 ? 100
                          : (nr.nr_rssi <= -100 ? 0 : (2 * (nr.nr_rssi + 100)));
  return close(fd), d_fmt(s, sizeof(s), "[%s]", d_dots(q));
}

static char *d_net(const char *ifn) {
  static char s[D_BUF];
  static uint64_t in, out;
  struct ifaddrs *ifas, *ifa;
  struct if_data *ifd;
  uint64_t ib = 0, ob = 0;
  char is[FMT_SCALED_STRSIZE], os[FMT_SCALED_STRSIZE], f = 0, *w;

  if (getifaddrs(&ifas) == -1)
    return d_warn("getifaddrs failed");
  for (ifa = ifas; ifa; ifa = ifa->ifa_next)
    if (!strcmp(ifa->ifa_name, ifn) && (ifd = (struct if_data *)ifa->ifa_data))
      ib += ifd->ifi_ibytes, ob += ifd->ifi_obytes, f = 1;
  freeifaddrs(ifas);
  if (!f)
    return "interface failed";
  if (fmt_scaled(in ? ib - in : 0, is) == -1 ||
      fmt_scaled(out ? ob - out : 0, os) == -1)
    return d_warn("fmt_scaled failed");
  return (in = ib, out = ob, w = d_wifi(ifn),
          strlen(w) ? d_fmt(s, sizeof(s), "↑ %s/s ↓ %s/s %s", os, is, w)
                    : d_fmt(s, sizeof(s), "↑ %s/s ↓ %s/s", os, is));
}

static char *d_perf(void) {
  static char s[D_BUF];
  int mib[2] = {CTL_HW, HW_CPUSPEED}, frq, p;
  size_t sz = sizeof(frq);

  if (sysctl(mib, 2, &frq, &sz, NULL, 0) == -1)
    return d_warn("sysctl failed");
  mib[1] = HW_SETPERF, sz = sizeof(p);
  if (sysctl(mib, 2, &p, &sz, NULL, 0) == -1)
    return d_warn("sysctl failed");
  return d_fmt(s, sizeof(s), "%0.1fGHz [%d%%]", frq / (double)1000, p);
}
static char *d_cmus(void) {
  static char s[D_BUF];
  FILE *cmus = popen("/home/derek/bin/cmus.sh", "r");
  if (cmus != NULL) {
    char *line;
    char buf[1000];
    line = fgets(buf, sizeof buf, cmus);
    pclose(cmus);
    return d_fmt(s, sizeof(s), " %s", line);
  }
  return NULL;
}

static char *d_cpu(void) {
  static char s[D_BUF];
  static long cpu[CPUSTATES];
  int mib[2] = {CTL_KERN, KERN_CPTIME}, p;
  long c[CPUSTATES];
  size_t sz = sizeof(c);

  if (sysctl(mib, 2, &c, &sz, NULL, 0) == -1)
    return d_warn("sysctl failed");
  p = (c[CP_USER] - cpu[CP_USER] + c[CP_SYS] - cpu[CP_SYS] + c[CP_NICE] -
       cpu[CP_NICE]) /
      (double)(c[CP_USER] - cpu[CP_USER] + c[CP_SYS] - cpu[CP_SYS] +
               c[CP_NICE] - cpu[CP_NICE] + c[CP_IDLE] - cpu[CP_IDLE]) *
      100;
  memmove(cpu, c, sizeof(cpu));
  return d_fmt(s, sizeof(s), " %d%% %s %s", p, d_bar(p), d_perf());
}

static void d_win(Display *d, XFontStruct *f) {
  const char *m = "Battery is low.", *n = "dstat";
  int s = DefaultScreen(d), ww = 128, wh = 64;
  Window w = XCreateSimpleWindow(d, RootWindow(d, s), DisplayWidth(d, s) / 2,
                                 DisplayHeight(d, s) / 2, ww, wh, 1,
                                 BlackPixel(d, s), 0x202020L);
  Atom ad = XInternAtom(d, "WM_DELETE_WINDOW", False),
       an = XInternAtom(d, "_NET_WM_NAME", False),
       ai = XInternAtom(d, "_NET_WM_ICON_NAME", False),
       au = XInternAtom(d, "UTF8_STRING", False);
  XGCValues gcv;
  GC gc = XCreateGC(d, w, 0, &gcv);
  XEvent e;

  XChangeProperty(d, w, an, au, 8, 0, (unsigned char *)n, strlen(n));
  XChangeProperty(d, w, ai, au, 8, 0, (unsigned char *)n, strlen(n));
  XSetTransientForHint(d, w, RootWindow(d, s));
  XSetWMProtocols(d, w, &ad, 1);
  XSelectInput(d, w, ExposureMask);
  XSetFont(d, gc, f->fid);
  XSetForeground(d, gc, 0xc0c0c0L);
  XMapWindow(d, w);
  for (;;) {
    XNextEvent(d, &e);
    if (e.type == Expose)
      XDrawString(d, w, gc, (ww - XTextWidth(f, m, strlen(m))) / 2,
                  (wh + f->ascent + f->descent) / 2, m, strlen(m));
    else if (e.type == ClientMessage)
      break;
  }
  XFreeGC(d, gc);
  XDestroyWindow(d, w);
}

static char *d_bat(int fd, Display *d, XFontStruct *f) {
  static char s[D_BUF], w;
  struct apm_power_info api;

  if (ioctl(fd, APM_IOC_GETPOWER, &api) == -1)
    return d_warn("ioctl failed");
  if (!w && api.ac_state != APM_AC_ON && api.minutes_left <= 10)
    d_win(d, f), w = 1;
  return (api.ac_state == APM_AC_ON)
             ? (w = 0, d_fmt(s, sizeof(s), "⚡ %d%% %s [A/C]", api.battery_life,
                             d_bar(api.battery_life)))
             : d_fmt(s, sizeof(s), "⚡ %d%% %s [%u:%02u]", api.battery_life,
                     d_bar(api.battery_life), api.minutes_left / 60,
                     api.minutes_left % 60);
}

static char *d_temp(void) {
  static char s[D_BUF];
  struct sensordev sd;
  struct sensor sn;
  size_t sd_sz = sizeof(sd), sn_sz = sizeof(sn);
  int mib[5] = {CTL_HW, HW_SENSORS, 0, SENSOR_TEMP, 0};
  int64_t t = -1;

  for (mib[2] = 0;; mib[2]++) {
    if (sysctl(mib, 3, &sd, &sd_sz, NULL, 0) == -1) {
      if (errno == ENXIO)
        continue;
      else if (errno == ENOENT)
        break;
      return d_warn("sysctl failed");
    }
    for (mib[4] = 0; mib[4] < sd.maxnumt[SENSOR_TEMP]; mib[4]++) {
      if (sysctl(mib, 5, &sn, &sn_sz, NULL, 0) == -1) {
        if (errno == ENXIO)
          continue;
        else if (errno == ENOENT)
          break;
        return d_warn("sysctl failed");
      }
      if (sn_sz && !(sn.flags & SENSOR_FINVALID))
        t = sn.value > t ? sn.value : t;
    }
  }
  return t == -1
             ? "temperature failed"
             : d_fmt(s, sizeof(s), ": %.1f°C", (t - 273150000) / 1000000.0);
}

static char *d_vol(int fd) {
  static char s[D_BUF];
  static int cls = -1;
  struct mixer_devinfo mdi;
  struct mixer_ctrl mc;
  int v = -1, m = -1, p;

  for (mdi.index = 0; cls == -1; mdi.index++) {
    if (ioctl(fd, AUDIO_MIXER_DEVINFO, &mdi) == -1)
      return d_warn("ioctl failed");
    if (mdi.type == AUDIO_MIXER_CLASS && !strcmp(mdi.label.name, AudioCoutputs))
      cls = mdi.index;
  }
  for (mdi.index = 0; v == -1 || m == -1; mdi.index++) {
    if (ioctl(fd, AUDIO_MIXER_DEVINFO, &mdi) == -1)
      return d_warn("ioctl failed");
    if (mdi.mixer_class == cls && ((mdi.type == AUDIO_MIXER_VALUE &&
                                    !strcmp(mdi.label.name, AudioNmaster)) ||
                                   (mdi.type == AUDIO_MIXER_ENUM &&
                                    !strcmp(mdi.label.name, AudioNmute)))) {
      mc.dev = mdi.index, mc.type = mdi.type;
      if (ioctl(fd, AUDIO_MIXER_READ, &mc) == -1)
        return d_warn("ioctl failed");
      if (mc.type == AUDIO_MIXER_VALUE)
        v = mc.un.value.num_channels == 1
                ? mc.un.value.level[AUDIO_MIXER_LEVEL_MONO]
                : (mc.un.value.level[AUDIO_MIXER_LEVEL_LEFT] >
                           mc.un.value.level[AUDIO_MIXER_LEVEL_RIGHT]
                       ? mc.un.value.level[AUDIO_MIXER_LEVEL_LEFT]
                       : mc.un.value.level[AUDIO_MIXER_LEVEL_RIGHT]);
      else if (mc.type == AUDIO_MIXER_ENUM)
        m = mc.un.ord;
    }
  }
  return v == -1
             ? "volume failed"
             : (m == -1
                    ? "mute failed"
                    : (m ? d_fmt(s, sizeof(s), "ﰝ mute")
                         : (p = ((v * 100) / 255),
                            d_fmt(s, sizeof(s), "ﰝ %d%% %s", p, d_bar(p)))));
}

static char *d_time(void) {
  static char s[D_BUF];
  struct tm *tm;
  time_t ts;

  if ((ts = time(NULL)) == ((time_t)-1))
    return d_warn("time failed");
  if (!(tm = localtime(&ts)))
    return d_warn("localtime failed");
  if (!strftime(s, sizeof(s), "%H:%M", tm))
    return d_warn("strftime failed");
  return s;
}

static void d_run(const char *ifn) {
  Display *d;
  XFontStruct *f;
  int a = -1, m = -1;
  char s[LINE_MAX];

  if (!(d = XOpenDisplay(NULL)))
    err(1, "XOpenDisplay failed");
  if (!(f = XLoadQueryFont(d, "-*-terminus-medium-*")) &&
      !(f = XLoadQueryFont(d, "fixed")))
    err(1, "XLoadQueryFont failed");
  if ((a = open("/dev/apm", O_RDONLY)) == -1 ||
      (m = open("/dev/mixer", O_RDONLY)) == -1)
    err(1, "open failed");
  for (;;) {
    XStoreName(d, DefaultRootWindow(d),
               d_fmt(s, sizeof(s),
                     d_net(ifn),
                     d_temp(), d_vol(m), d_cpu(), d_bat(a, d, f), d_time()));
    XSync(d, False), sleep(1);
  }
  close(m), close(a);
  XUnloadFont(d, f->fid);
  XCloseDisplay(d);
}

int main(int argc, char *argv[]) {
  if (argc == 2 && !strcmp(argv[1], "version")) {
    puts("dstat " D_V " (c) " D_YR " Joerg Jung");
    return 0;
  }
  if (argc != 2)
    errx(1, "usage: dstat <if>\n%14sdstat version", "");
  if (setpriority(PRIO_PROCESS, getpid(), 10))
    err(1, "setpriority failed");
  if (setvbuf(stdout, NULL, _IONBF,
              0)) /* allow unbuffered pipe output to others */
    err(1, "setvbuf failed");
  d_run(argv[1]);
  return 0;
}
