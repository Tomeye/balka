#!/bin/sh

grep -vxf keywords_B0D9KZKYWX competitors_keywords_sorted | uniq -c | sort > missing.txt