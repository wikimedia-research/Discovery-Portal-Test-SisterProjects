# Daily clickthrough rate by section on first visit
sessions %>%
  keep_where(visit == 1) %>%
  group_by(date, group) %>%
  summarize(search = sum(clicked == "search", na.rm = TRUE)/n(),
            `other projects` = sum(clicked == "other projects", na.rm = TRUE)/n(),
            `primary links` = sum(clicked == "primary links", na.rm = TRUE)/n(),
            `secondary links` = sum(clicked == "secondary links", na.rm = TRUE)/n()) %>%
  gather(clicked, ctr, -c(1, 2)) %>%
  ggplot(aes(x = date, y = ctr, color = clicked, linetype = group)) +
  geom_line() +
  scale_y_continuous(labels = scales::percent_format())

visited_other_projects <- sessions %>%
  keep_where(clicked == "other projects" & visit > 0)

# Number of visits per session
sessions %>%
  keep_where(session %in% visited_other_projects$session) %>%
  group_by(group, session) %>%
  summarize(visits = max(visit)) %>%
  group_by(group, visits) %>%
  summarize(sessions = n()) %>%
  mutate(prop = sessions/sum(sessions)) %>%
  ggplot(aes(x = factor(visits), y = sessions, fill = group)) +
  geom_bar(stat = "identity", position = "dodge")
  # scale_y_continuous(labels = scales::percent_format())
