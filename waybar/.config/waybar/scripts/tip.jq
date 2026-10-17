# Turn a plain-text waybar tooltip into Pango markup matching the swaync theme:
#   line 1                    -> bold title
#   "Label  value" (2+ sp)    -> dim label, normal value
#   "Click…/Right-click…/…"   -> small dim hint
#   star glyphs               -> yellow (filled/half) or dim (empty)
# Everything is escaped, so data from services can't break the markup.
def esc: gsub("&"; "&amp;") | gsub("<"; "&lt;") | gsub(">"; "&gt;");
def dim: "<span color=\"#7b88a1\">\(.)</span>";
def stars: gsub("(?<s>[󰓎󰓐]+)"; "<span size=\"large\" letter_spacing=\"3072\" color=\"#ebcb8b\">\(.s)</span>") | gsub("(?<s>󰓒+)"; "<span size=\"large\" letter_spacing=\"3072\" color=\"#616e88\">\(.s)</span>");
def line:
  if test("^(Click|Right-click|Middle|Scroll)") then "<span size=\"small\" color=\"#7b88a1\">\(esc)</span>"
  elif test("^\\S.*?\\S  +\\S") then
    (capture("^(?<k>\\S.*?\\S)(?<sp>  +)(?<v>\\S.*)$") | "\(.k | esc | dim)\(.sp)\(.v | esc)")
  else esc end;

if (.tooltip // "") == "" then . else
  .tooltip |= (split("\n") | to_entries
    | map(if .key == 0 then "<span weight=\"bold\" color=\"#eceff4\">\(.value | esc)</span>" else (.value | line | stars) end)
    | join("\n"))
end
