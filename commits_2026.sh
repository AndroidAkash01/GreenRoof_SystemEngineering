#!/bin/bash

START_DATE="2026-01-01"
END_DATE="2026-04-30"

CURRENT=$(date -j -f "%Y-%m-%d" "$START_DATE" +"%s")
END=$(date -j -f "%Y-%m-%d" "$END_DATE" +"%s")

while [ $CURRENT -le $END ]; do

    MONTH=$(date -r $CURRENT +"%m")

    # More active March-April, medium Jan-Feb
    if [[ "$MONTH" == "03" || "$MONTH" == "04" ]]; then
        ACTIVE_WEEK_CHANCE=65
    else
        ACTIVE_WEEK_CHANCE=45
    fi

    RANDOM_WEEK=$((RANDOM % 100))

    if [ $RANDOM_WEEK -lt $ACTIVE_WEEK_CHANCE ]; then

        # Mostly 3-4 days, sometimes 1-2
        RANDOM_DAYS=$((RANDOM % 100))

        if [ $RANDOM_DAYS -lt 70 ]; then
            DAYS=$((3 + RANDOM % 2))
        else
            DAYS=$((1 + RANDOM % 2))
        fi

        declare -A USED_DAYS

        for ((i=0; i<DAYS; i++)); do

            # Mostly Wednesday-Sunday
            RANDOM_DAY_PATTERN=$((RANDOM % 100))

            if [ $RANDOM_DAY_PATTERN -lt 85 ]; then
                DAY_OFFSET=$((2 + RANDOM % 5))   # Wed-Sun
            else
                DAY_OFFSET=$((RANDOM % 7))       # Mon-Sun
            fi

            if [[ -n "${USED_DAYS[$DAY_OFFSET]}" ]]; then
                continue
            fi

            USED_DAYS[$DAY_OFFSET]=1

            DAY_TS=$((CURRENT + DAY_OFFSET * 86400))
            DATE_STR=$(date -r $DAY_TS +"%Y-%m-%d")

            HOUR=$((10 + RANDOM % 10))
            MIN=$((RANDOM % 60))

            FULL_DATE="${DATE_STR}T${HOUR}:${MIN}:00"

            echo "2026 project update $FULL_DATE" >> progress_2026.txt

            git add .

            GIT_AUTHOR_DATE="$FULL_DATE" \
            GIT_COMMITTER_DATE="$FULL_DATE" \
            git commit -m "Project update"

        done
    fi

    CURRENT=$((CURRENT + 7 * 86400))

done

echo "Done creating 2026 commits."
