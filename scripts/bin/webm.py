#!/usr/bin/env python
from pymediainfo import MediaInfo
import sys, argparse, os
import subprocess

def main(argv):
    FFMPEG_BIN = 'ffmpeg'

    parser = argparse.ArgumentParser(description='Small utility to convert video files to webm files for use on 4chan')
    parser.add_argument('-s', '--start', help='Position to start from source in hh:mm:ss format', 
                        required=True)
    parser.add_argument('-l', '--length', help='Length of video in seconds',
                        required=True)
    parser.add_argument('-i', '--input', help='Input file', required=True)
    parser.add_argument('-o', '--out', help='Output file', required=False)
    parser.add_argument('-p', '--scale', help='Scale width to SCALE pixels', 
                        required=False)
    parser.add_argument('-b', '--bitrate', help='Bitrate', required=False)
    parser.add_argument('-m', '--size', help='Output size in bytes',
                        required=False)
    parser.add_argument('-a', '--audio', help='Also encode audio',
                        required=False)

    args = parser.parse_args()

    if not args.size:
        outsize = 25165824  # 3MB
    else:
        outsize = args.size

    bitrate = int(outsize / float(args.length)) # calculate bitrate
    
    # Get bitrate from the input file
    media_info = MediaInfo.parse(args.input)
    for track in media_info.tracks:
        if track.track_type == 'Video':
            input_bitrate = track.bit_rate
    
    """
    Don't use a higher bitrate than the source, it will unnecessarily increase
    file size
    """
    if bitrate > input_bitrate:
        bitrate = input_bitrate

    if not args.out:
        outfile = "%s.webm" % os.path.splitext(args.input)[0]
    else:
        outfile = str(args.out)

    command = [FFMPEG_BIN,
               '-i', args.input,        # input file
               '-y',                    # overwrite file 
               '-c:v', 'libvpx',        # video codec (VP8)
               '-crf', '4',             # constant rate factor
               '-ss', args.start,       # start postion
               '-t', args.length,       # total time
               '-an',                   # strip audio
              ]

    if bitrate is not None:
        command.append('-b:v')
        command.append(str(bitrate))

    if args.scale:
        command.append('-vf') 
        command.append("scale=%s:-1" % args.scale)

    command.append(outfile)

    print "Executing command: "
    for c in command:
        print(c),


    pipe = subprocess.Popen(command, stdout=subprocess.PIPE, bufsize=10**8)

if __name__ == "__main__":
    main(sys.argv)
