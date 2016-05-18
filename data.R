start_date <- as.Date("2016-05-03")
end_date <- as.Date("2016-05-10")
events <- do.call(rbind, lapply(seq(start_date, end_date, "day"), function(date) {
  cat("Fetching Portal EL data from", as.character(date), "\n")
  data <- wmf::build_query("SELECT LEFT(timestamp, 8) AS date,
                           timestamp AS ts,
                           event_session_id AS session,
                           event_destination AS destination,
                           event_event_type AS type,
                           event_section_used AS section_used,
                           event_cohort AS test_group",
                           date = date,
                           table = "WikipediaPortal_14377354",
                           conditionals = "event_cohort IN('descriptive-text-a', 'descriptive-text-b')")
  return(data)
}))
library(magrittr)
events$date %<>% lubridate::ymd()
events$ts %<>% lubridate::ymd_hms()

readr::write_rds(events, "~/portal-sister-links-test.rds", "gz")

dir.create("data")
system("scp stat2:/home/bearloga/portal-sister-links-test.rds data/")
