#!/bin/bash

START_DATE="2025-01-01"
END_DATE="2025-05-01"

CURRENT=$(date -j -f "%Y-%m-%d" "$START_DATE" +"%s")
END=$(date -j -f "%Y-%m-%d" "$END_DATE" +"%s")

while [ $CURRENT -le $END ]; do

    ACTIVE=$((RANDOM % 4))

    if [ $ACTIVE -lt 2 ]; then

        DAYS=$((3 + RANDOM % 2))

        declare -A USED_DAYS

        for ((i=0; i<DAYS; i++)); do

            if [ $((RANDOM % 10)) -lt 8 ]; then
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

            HOUR=$((10 + RANDOM % 10))
            MIN=$((RANDOM % 60))

            FULL_DATE="${DATE_STR}T${HOUR}:${MIN}:00"

            GIT_AUTHOR_DATE="$FULL_DATE" \
            GIT_COMMITTER_DATE="$FULL_DATE" \
            git commit --allow-empty -m "Project progress update"

        done
    fi

    CURRENT=$((CURRENT + 7 * 86400))

done
