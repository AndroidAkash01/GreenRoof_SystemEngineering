#!/bin/bash

START_DATE="2025-01-01"
END_DATE="2026-05-01"

CURRENT=$(date -j -f "%Y-%m-%d" "$START_DATE" +"%s")
END=$(date -j -f "%Y-%m-%d" "$END_DATE" +"%s")

while [ $CURRENT -le $END ]; do

    MONTH=$(date -r $CURRENT +"%m")

    # Summer months -> much lower activity
    if [[ "$MONTH" == "06" || "$MONTH" == "07" || "$MONTH" == "08" ]]; then
        ACTIVE_CHANCE=8
    else
        ACTIVE_CHANCE=4
    fi

    RANDOM_WEEK=$((RANDOM % 10))

    if [ $RANDOM_WEEK -lt $ACTIVE_CHANCE ]; then

        # Mostly 3-4 days, sometimes 1-2
        RANDOM_DAYS=$((RANDOM % 10))

        if [ $RANDOM_DAYS -lt 7 ]; then
            DAYS=$((3 + RANDOM % 2))
        else
            DAYS=$((1 + RANDOM % 2))
        fi

        declare -A USED_DAYS

        for ((i=0; i<DAYS; i++)); do

            # Mostly Wed-Sun
            RANDOM_RANGE=$((RANDOM % 10))

            if [ $RANDOM_RANGE -lt 8 ]; then
                DAY_OFFSET=$((2 + RANDOM % 5))
            else
                DAY_OFFSET=$((RANDOM % 7))
            fi

            if [[ -n "${USED_DAYS[$DAY_OFFSET]}" ]]; then
                continue
            fi

            USED_DAYS[$DAY_OFFSET]=1

            DAY_TS=$((CURRENT + DAY_OFFSET * 86400))

            DATE_STR=$(date -r $DAY_TS +"%Y-%m-%d")

            HOUR=$((11 + RANDOM % 9))
            MIN=$((RANDOM % 60))

            FULL_DATE="${DATE_STR}T${HOUR}:${MIN}:00"

            echo "$FULL_DATE"

            echo "$FULL_DATE" >> activity_log.txt

            echo "$FULL_DATE" >> timeline.txt

            echo "update $RANDOM" >> progress.txt

            git add .

            GIT_AUTHOR_DATE="$FULL_DATE" \
            GIT_COMMITTER_DATE="$FULL_DATE" \
            git commit -m "Project update"

        done
    fi

    CURRENT=$((CURRENT + 7 * 86400))

done
