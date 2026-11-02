#!/usr/bin/env bash
# Claude Code status line: dir, git branch, model, context %, cost, prompt-cache countdown.
PATH="$HOME/.local/share/mise/shims:$PATH"
CACHE_TTL=3600 # prompt-cache TTL in seconds (drops to 300 in usage overage)

in=$(cat)
j() { jq -r "$1 // empty" <<<"$in"; }

dir=$(j .workspace.current_dir)
model=$(j .model.display_name)
effort=$(j .effort.level)
ctx=$(j .context_window.used_percentage)
cost=$(j .cost.total_cost_usd)
transcript=$(j .transcript_path)

branch=$(git -C "$dir" branch --show-current 2>/dev/null)

cache="cache cold"
if [[ -f $transcript ]]; then
  left=$(( CACHE_TTL - $(date +%s) + $(date -r "$transcript" +%s) ))
  (( left > 0 )) && cache=$(printf 'cache %d:%02d' $((left / 60)) $((left % 60)))
fi

dir=${dir/#$HOME/\~}
(( ${#dir} > 30 )) && dir=${dir##*/}
(( ${#dir} > 25 )) && dir="${dir:0:24}…"
printf '\033[01;34m%s\033[00m' "$dir"
[[ -n $branch ]] && printf ' \033[35m(%s)\033[00m' "$branch"
printf ' | \033[36m%s\033[00m' "$model"
[[ -n $effort ]] && printf ' \033[2m%s\033[00m' "$effort"
[[ -n $ctx ]] && printf ' | ctx %.0f%%' "$ctx"
[[ -n $cost ]] && printf ' | $%.2f' "$cost"
printf ' | %s' "$cache"
h5=$(j '.rate_limits.five_hour.used_percentage | values | 100 - .')
d7=$(j '.rate_limits.seven_day.used_percentage | values | 100 - .')
lim() { # label, remaining %: yellow below 20, red below 10
  local c=0 n=$(printf '%.0f' "$2")
  (( n < 20 )) && c=33
  (( n < 10 )) && c=31
  printf ' | \033[%sm%s %d%%\033[00m' "$c" "$1" "$n"
}
[[ -n $h5 ]] && lim 5h "$h5"
[[ -n $d7 ]] && lim 7d "$d7"
exit 0
