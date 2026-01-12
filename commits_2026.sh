#!/bin/bash

# 2026 realistic commit history generator
# Pattern:
# - January to end of April 2026
# - Mostly 3–4 active days/week
# - Sometimes only 1–2 days/week
# - Mostly Wednesday to Sunday
# - Some days have more commits to create GitHub gradient
# - March and April have slightly more activity

START_DATE="2026-01-01"
END_DATE="2026-04-30"

CURRENT=$(date -j -f "%Y-%m-%d" "$START_DATE" +"%s")
END=$(date -j -f "%Y-%m-%d" "$END_DATE" +"%s")

while [ $CURRENT -le $END ]; do

    MONTH=$(date -r $CURRENT +"%m")

    # -------------------------
    # Activity chance by month
    # -------------------------

    # More work during March-April
    if [[ "$MONTH" == "03" || "$MONTH" == "04" ]]; then
        ACTIVE_WEEK_CHANCE=75

    # Medium activity during Jan-Feb
    else
        ACTIVE_WEEK_CHANCE=55
    fi

    RANDOM_WEEK=$((RANDOM % 100))

    if [ $RANDOM_WEEK -lt $ACTIVE_WEEK_CHANCE ]; then

        # -------------------------
        # Number of active days/week
        # -------------------------

        RANDOM_DAYS=$((RANDOM % 100))

        # Mostly 3–4 days/week
        if [ $RANDOM_DAYS -lt 75 ]; then
            DAYS=$((3 + RANDOM % 2))

        # Sometimes only 1–2 days/week
        else
            DAYS=$((1 + RANDOM % 2))
        fi

        declare -A USED_DAYS

        for ((i=0; i<DAYS; i++)); do

            # -------------------------
            # Pick day mostly Wed-Sun
            # 0=Mon, 1=Tue, 2=Wed, 3=Thu, 4=Fri, 5=Sat, 6=Sun
            # -------------------------

            RANDOM_DAY_PATTERN=$((RANDOM % 100))

            if [ $RANDOM_DAY_PATTERN -lt 85 ]; then
                DAY_OFFSET=$((2 + RANDOM % 5))   # Wed-Sun
            else
                DAY_OFFSET=$((RANDOM % 7))       # Mon-Sun
            fi

            # Avoid duplicate days in the same week
            if [[ -n "${USED_DAYS[$DAY_OFFSET]}" ]]; then
                continue
            fi

            USED_DAYS[$DAY_OFFSET]=1

            DAY_TS=$((CURRENT + DAY_OFFSET * 86400))
            DATE_STR=$(date -r $DAY_TS +"%Y-%m-%d")

            # -------------------------
            # Commits per active day
            # Creates GitHub gradient:
            # light green = 1 commit
            # medium green = 2–3 commits
            # dark green = 4–6 commits
            # -------------------------

            RANDOM_INTENSITY=$((RANDOM % 100))

            if [ $RANDOM_INTENSITY -lt 50 ]; then
                COMMITS_TODAY=1

            elif [ $RANDOM_INTENSITY -lt 85 ]; then
                COMMITS_TODAY=$((2 + RANDOM % 2))   # 2–3 commits

            else
                COMMITS_TODAY=$((4 + RANDOM % 3))   # 4–6 commits
            fi

            for ((c=0; c<COMMITS_TODAY; c++)); do

                HOUR=$((10 + RANDOM % 11))
                MIN=$((RANDOM % 60))
                SEC=$((RANDOM % 60))

                FULL_DATE="${DATE_STR}T${HOUR}:${MIN}:${SEC}"

                echo "2026 project update $FULL_DATE - $RANDOM" >> progress_2026.txt

                git add .

                GIT_AUTHOR_DATE="$FULL_DATE" \
                GIT_COMMITTER_DATE="$FULL_DATE" \
                git commit -m "Project update"

            done

        done
    fi

    # Move to next week
    CURRENT=$((CURRENT + 7 * 86400))

done

echo "Done. Realistic 2026 commits created from $START_DATE to $END_DATE."#!/bin/bash

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
