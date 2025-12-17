#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Extract basic info
model=$(echo "$input" | jq -r '.model.display_name')
model_id=$(echo "$input" | jq -r '.model.id')
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
style=$(echo "$input" | jq -r '.output_style.name')
user=$(whoami)
host=$(hostname -s)
dir=$(basename "$cwd")

# Extract token information
session_input=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
session_output=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')
context_size=$(echo "$input" | jq -r '.context_window.context_window_size // 0')

# Calculate session cost based on model pricing (per million tokens)
case "$model_id" in
    *"opus"*"4"*)
        # Claude Opus 4 and 4.5: $15 input, $75 output
        input_price=15
        output_price=75
        ;;
    *"sonnet"*"4"*)
        # Claude Sonnet 4 and 4.5: $3 input, $15 output
        input_price=3
        output_price=15
        ;;
    *"opus"*"3"*)
        # Claude 3 Opus: $15 input, $75 output
        input_price=15
        output_price=75
        ;;
    *"sonnet"*"3-5"*)
        # Claude 3.5 Sonnet: $3 input, $15 output
        input_price=3
        output_price=15
        ;;
    *"haiku"*)
        # Claude Haiku: $0.25 input, $1.25 output
        input_price=0.25
        output_price=1.25
        ;;
    *)
        # Default to Sonnet pricing
        input_price=3
        output_price=15
        ;;
esac

session_cost=$(awk "BEGIN {printf \"%.6f\", ($session_input * $input_price + $session_output * $output_price) / 1000000}")

# Get daily cost from ccusage (more accurate than Claude Code's value)
today_date=$(date +%Y-%m-%d)
daily_cost=$(ccusage daily --json 2>/dev/null | jq -r --arg d "$today_date" '.daily[-1] | if .date == $d then .totalCost else 0 end' 2>/dev/null)
# Fallback to Claude Code's value if ccusage fails
if [ -z "$daily_cost" ] || [ "$daily_cost" = "null" ]; then
    daily_cost=$(echo "$input" | jq -r '.cost.daily_cost_usd // 0')
fi

# Calculate total session tokens
session_total=$((session_input + session_output))

# Git status
git_info=""
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git -C "$cwd" --no-optional-locks branch --show-current 2>/dev/null)
    if [ -n "$branch" ]; then
        if git -C "$cwd" --no-optional-locks diff-index --quiet HEAD -- 2>/dev/null; then
            git_info=$(printf "(%s)" "$branch")
        else
            git_info=$(printf "\033[31m(%s)\033[0m" "$branch")
        fi
    fi
fi

# Print status line
printf "\033[36m%s\033[0m:\033[35m%s\033[0m" "$host" "$dir"
[ -n "$git_info" ] && printf "%s" "$git_info"
printf " | \033[34m%s\033[0m" "$model"
[ "$style" != "null" ] && [ -n "$style" ] && printf " | \033[33m%s\033[0m" "$style"

# Cost information with color thresholds
# Session: green < $10, yellow $10-$20, red >= $20
if (( $(echo "$session_cost >= 20" | bc -l) )); then
    session_color="\033[31m"  # Red
elif (( $(echo "$session_cost >= 10" | bc -l) )); then
    session_color="\033[33m"  # Yellow
else
    session_color="\033[32m"  # Green
fi

# Today: green < $30, yellow $30-$60, red >= $60
if (( $(echo "$daily_cost >= 60" | bc -l) )); then
    today_color="\033[31m"  # Red
elif (( $(echo "$daily_cost >= 30" | bc -l) )); then
    today_color="\033[33m"  # Yellow
else
    today_color="\033[32m"  # Green
fi

printf " | Session: %b\$%.3f\033[0m" "$session_color" "$session_cost"
printf " | Today: %b\$%.3f\033[0m" "$today_color" "$daily_cost"

# Context usage visualization
if [ "$context_size" -gt 0 ]; then
    usage_percent=$(awk "BEGIN {printf \"%.1f\", ($session_total / $context_size) * 100}")
    bar_width=10
    filled=$(awk "BEGIN {printf \"%.0f\", ($usage_percent / 100) * $bar_width}")

    # Color based on usage
    if (( $(echo "$usage_percent < 50" | bc -l) )); then
        color="\033[32m"  # Green
    elif (( $(echo "$usage_percent < 80" | bc -l) )); then
        color="\033[33m"  # Yellow
    else
        color="\033[31m"  # Red
    fi

    # Build progress bar (no brackets)
    bar=""
    for ((i=0; i<filled && i<bar_width; i++)); do bar+="█"; done
    for ((i=filled; i<bar_width; i++)); do bar+="░"; done

    printf " | Context: %b%s %.1f%%\033[0m" "$color" "$bar" "$usage_percent"
else
    printf " | Context: \033[36munlimited\033[0m"
fi

echo
