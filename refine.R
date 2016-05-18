library(magrittr)
library(tidyr)
import::from(dplyr, group_by, summarize, ungroup, mutate, rename, keep_where = filter, tbl_df, arrange)

events <- tbl_df(readr::read_rds("data/portal-sister-links-test.rds"))

sessions <- events %>%
  group_by(session) %>%
  arrange(ts) %>%
  mutate(visit = cumsum(type == "landing")) %>%
  group_by(session, visit) %>%
  summarize(date = head(date, 1),
            group = ifelse(head(test_group, 1) == "descriptive-text-a", "controls", "test"),
            clickthrough = "clickthrough" %in% type,
            clicked = tail(section_used, 1),
            seconds_between = difftime(max(ts), min(ts), units = "secs")) %>%
  mutate(seconds_between = ifelse(is.na(clicked), as.numeric(NA), seconds_between))

readr::write_rds(sessions, "data/refined.rds", "gz")
