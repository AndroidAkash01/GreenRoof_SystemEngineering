#!/bin/bash

# Realistic commit history generator
# Pattern:
# - Mostly 3–4 active days per week
# - Mostly Wednesday to Sunday
# - Sometimes only 1–2 days per week
# - Very low activity during June–August
# - Some days have more commits to create GitHub gradient
# - Covers 2025 and 2026 until end of April

START_DATE="2025-01-01"
END_DATE="2026-04-30"

CURRENT=$(date -j -f "%Y-%m-%d" "$START_DATE" +"%s")
END=$(date -j -f "%Y-%m-%d" "$END_DATE" +"%s")

while [ $CURRENT -le $END ]; do

    MONTH=$(date -r $CURRENT +"%m")
    YEAR=$(date -r $CURRENT +"%Y")

    # -------------------------
    # Activity chance by month
    # -------------------------

    # Very low summer activity
    if [[ "$MONTH" == "06" || "$MONTH" == "07" || "$MONTH" == "08" ]]; then
        ACTIVE_WEEK_CHANCE=15

    # More work during March-May
    elif [[ "$MONTH" == "03" || "$MONTH" == "04" || "$MONTH" == "05" ]]; then
        ACTIVE_WEEK_CHANCE=70

    # Good activity Jan-Feb 2026
    elif [[ "$YEAR" == "2026" && ( "$MONTH" == "01" || "$MONTH" == "02" ) ]]; then
        ACTIVE_WEEK_CHANCE=55

    # Medium activity other months
    else
        ACTIVE_WEEK_CHANCE=45
    fi

    RANDOM_WEEK=$((RANDOM % 100))

    if [ $RANDOM_WEEK -lt $ACTIVE_WEEK_CHANCE ]; then

        # -------------------------
        # Number of active days/week
        # -------------------------

        if [[ "$MONTH" == "06" || "$MONTH" == "07" || "$MONTH" == "08" ]]; then
            # Summer: only 1 active day if active
            DAYS=1
        else
            RANDOM_DAYS=$((RANDOM % 100))

            if [ $RANDOM_DAYS -lt 75 ]; then
                DAYS=$((3 + RANDOM % 2))   # 3–4 days
            else
                DAYS=$((1 + RANDOM % 2))   # 1–2 days
            fi
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

            if [[ -n "${USED_DAYS[$DAY_OFFSET]}" ]]; then
                continue
            fi

            USED_DAYS[$DAY_OFFSET]=1

            DAY_TS=$((CURRENT + DAY_OFFSET * 86400))
            DATE_STR=$(date -r $DAY_TS +"%Y-%m-%d")

            # -------------------------
            # Commits per active day
            # This creates gradient:
            # light green = 1 commit
            # medium green = 2–3 commits
            # darker green = 4–6 commits
            # -------------------------

            RANDOM_INTENSITY=$((RANDOM % 100))

            if [[ "$MONTH" == "06" || "$MONTH" == "07" || "$MONTH" == "08" ]]; then
                COMMITS_TODAY=1
            else
                if [ $RANDOM_INTENSITY -lt 55 ]; then
                    COMMITS_TODAY=1
                elif [ $RANDOM_INTENSITY -lt 85 ]; then
                    COMMITS_TODAY=$((2 + RANDOM % 2))   # 2–3
                else
                    COMMITS_TODAY=$((4 + RANDOM % 3))   # 4–6
                fi
            fi

            for ((c=0; c<COMMITS_TODAY; c++)); do

                HOUR=$((10 + RANDOM % 11))
                MIN=$((RANDOM % 60))
                SEC=$((RANDOM % 60))

                FULL_DATE="${DATE_STR}T${HOUR}:${MIN}:${SEC}"

                echo "Project update $FULL_DATE - $RANDOM" >> progress.txt

                git add .

                GIT_AUTHOR_DATE="$FULL_DATE" \
                GIT_COMMITTER_DATE="$FULL_DATE" \
                git commit -m "Project update"

            done

        done
    fi

    CURRENT=$((CURRENT + 7 * 86400))

done

echo "Done. Realistic commits created from $START_DATE to $END_DATE."#!/bin/bash

# Realistic commit history generator
# Pattern:
# - Mostly 3–4 days/week
# - Mostly Wednesday to Sunday
# - Sometimes only 1–2 days/week
# - Very low activity during June–August
# - Around 40–50% working activity overall
# - Dates from 2025 to end of April 2026

START_DATE="2025-01-01"
END_DATE="2026-04-30"

CURRENT=$(date -j -f "%Y-%m-%d" "$START_DATE" +"%s")
END=$(date -j -f "%Y-%m-%d" "$END_DATE" +"%s")

while [ $CURRENT -le $END ]; do

    MONTH=$(date -r $CURRENT +"%m")

    # -------------------------
    # Decide activity by month
    # -------------------------

    # Summer vacation: very low activity
    # Goal: only around 5–6 total active days across June-August
    if [[ "$MONTH" == "06" || "$MONTH" == "07" || "$MONTH" == "08" ]]; then
        ACTIVE_WEEK_CHANCE=18   # low chance

    # March-May: slightly more active
    elif [[ "$MONTH" == "03" || "$MONTH" == "04" || "$MONTH" == "05" ]]; then
        ACTIVE_WEEK_CHANCE=55

    # September-November: medium active
    elif [[ "$MONTH" == "09" || "$MONTH" == "10" || "$MONTH" == "11" ]]; then
        ACTIVE_WEEK_CHANCE=45

    # Rest of the year: lower-medium active
    else
        ACTIVE_WEEK_CHANCE=35
    fi

    RANDOM_WEEK=$((RANDOM % 100))

    if [ $RANDOM_WEEK -lt $ACTIVE_WEEK_CHANCE ]; then

        # -------------------------
        # Decide number of workdays
        # -------------------------

        # Summer: usually only 1 day if active
        if [[ "$MONTH" == "06" || "$MONTH" == "07" || "$MONTH" == "08" ]]; then
            DAYS=1
        else
            RANDOM_DAYS=$((RANDOM % 100))

            # 70% chance: 3–4 days
            if [ $RANDOM_DAYS -lt 70 ]; then
                DAYS=$((3 + RANDOM % 2))

            # 30% chance: 1–2 days
            else
                DAYS=$((1 + RANDOM % 2))
            fi
        fi

        declare -A USED_DAYS

        for ((i=0; i<DAYS; i++)); do

            # -------------------------
            # Pick day of week
            # -------------------------

            RANDOM_DAY_PATTERN=$((RANDOM % 100))

            # 85% mostly Wednesday-Sunday
            # macOS date offsets from week start:
            # 0 = Monday, 1 = Tuesday, 2 = Wednesday, ... 6 = Sunday
            if [ $RANDOM_DAY_PATTERN -lt 85 ]; then
                DAY_OFFSET=$((2 + RANDOM % 5))   # Wed-Sun
            else
                DAY_OFFSET=$((RANDOM % 7))       # Mon-Sun
            fi

            # Avoid duplicate days in same week
            if [[ -n "${USED_DAYS[$DAY_OFFSET]}" ]]; then
                continue
            fi

            USED_DAYS[$DAY_OFFSET]=1

            DAY_TS=$((CURRENT + DAY_OFFSET * 86400))
            DATE_STR=$(date -r $DAY_TS +"%Y-%m-%d")

            # Random working time between 10:00 and 20:59
            HOUR=$((10 + RANDOM % 11))
            MIN=$((RANDOM % 60))

            FULL_DATE="${DATE_STR}T${HOUR}:${MIN}:00"

            echo "Project update on $FULL_DATE" >> progress.txt

            git add .

            GIT_AUTHOR_DATE="$FULL_DATE" \
            GIT_COMMITTER_DATE="$FULL_DATE" \
            git commit -m "Project update"

        done
    fi

    # Move to next week
    CURRENT=$((CURRENT + 7 * 86400))

done

echo "Done. Realistic commits created from $START_DATE to $END_DATE."#!/bin/bash

START_DATE="2025-01-01"
END_DATE="2026-04-30"

CURRENT=$(date -j -f "%Y-%m-%d" "$START_DATE" +"%s")
END=$(date -j -f "%Y-%m-%d" "$END_DATE" +"%s")

while [ $CURRENT -le $END ]; do

    MONTH=$(date -r $CURRENT +"%m")
    YEAR=$(date -r $CURRENT +"%Y")

    # ---------------- ACTIVITY LEVELS ----------------

    # Higher activity March-June
    if [[ "$MONTH" == "03" || "$MONTH" == "04" || "$MONTH" == "05" || "$MONTH" == "06" ]]; then
        ACTIVE_CHANCE=14

    # Summer lower activity
    elif [[ "$MONTH" == "07" || "$MONTH" == "08" ]]; then
        ACTIVE_CHANCE=3

    # Medium activity rest of year
    else
        ACTIVE_CHANCE=7
    fi

    RANDOM_WEEK=$((RANDOM % 10))

    if [ $RANDOM_WEEK -lt $ACTIVE_CHANCE ]; then

        # Mostly 3-4 days/week
        RANDOM_DAYS=$((RANDOM % 10))

        if [ $RANDOM_DAYS -lt 8 ]; then
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

            echo "update $RANDOM" >> progress.txt

            git add .

            GIT_AUTHOR_DATE="$FULL_DATE" \
            GIT_COMMITTER_DATE="$FULL_DATE" \
            git commit -m "Project update"

        done
    fi

    CURRENT=$((CURRENT + 7 * 86400))

done#!/bin/bash

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
