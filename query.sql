-- Dataset: 
-- GHTorrent, "2019-06-01", https://t.co/k8Oq1oD8uV?amp=1

-- Top 500 most starred repositories in a specified language,
-- e.g. C/C++.
SELECT
  w.repo_id,
  p.name,
  COUNT(*) AS num_stars
FROM
  `ghtorrentmysql1906.MySQL1906.watchers` w,
  `ghtorrentmysql1906.MySQL1906.projects` p,
  `ghtorrentmysql1906.MySQL1906.project_languages` pl
WHERE
  w.repo_id = p.id
  AND p.id = pl.project_id
  AND (pl.LANGUAGE = "c"
  OR pl.LANGUAGE = "c++")
GROUP BY
  repo_id,
  p.name
ORDER BY
  num_stars DESC
LIMIT
  500

-- The top 500 most starred repositories in each of the following languages:
-- Java, JavaScript, C/C++, Python, Ruby, PHP.
-- Stored as a view called `initial_projects` to indicate the initial set of repositories.
(SELECT
    w.repo_id,
    p.name,
    COUNT(*) AS num_stars
  FROM
    `ghtorrentmysql1906.MySQL1906.watchers` w,
    `ghtorrentmysql1906.MySQL1906.projects` p,
    `ghtorrentmysql1906.MySQL1906.project_languages` pl
  WHERE
    w.repo_id = p.id
    AND p.id = pl.project_id
    AND pl.LANGUAGE = "python"
  GROUP BY
    repo_id,
    p.name
  ORDER BY
    num_stars DESC
  LIMIT
    500)
UNION DISTINCT (
  SELECT
    w.repo_id,
    p.name,
    COUNT(*) AS num_stars
  FROM
    `ghtorrentmysql1906.MySQL1906.watchers` w,
    `ghtorrentmysql1906.MySQL1906.projects` p,
    `ghtorrentmysql1906.MySQL1906.project_languages` pl
  WHERE
    w.repo_id = p.id
    AND p.id = pl.project_id
    AND pl.LANGUAGE = "java"
  GROUP BY
    repo_id,
    p.name
  ORDER BY
    num_stars DESC
  LIMIT
    500)
UNION DISTINCT (
  SELECT
    w.repo_id,
    p.name,
    COUNT(*) AS num_stars
  FROM
    `ghtorrentmysql1906.MySQL1906.watchers` w,
    `ghtorrentmysql1906.MySQL1906.projects` p,
    `ghtorrentmysql1906.MySQL1906.project_languages` pl
  WHERE
    w.repo_id = p.id
    AND p.id = pl.project_id
    AND pl.LANGUAGE = "javascript"
  GROUP BY
    repo_id,
    p.name
  ORDER BY
    num_stars DESC
  LIMIT
    500 )
UNION DISTINCT (
  SELECT
    w.repo_id,
    p.name,
    COUNT(*) AS num_stars
  FROM
    `ghtorrentmysql1906.MySQL1906.watchers` w,
    `ghtorrentmysql1906.MySQL1906.projects` p,
    `ghtorrentmysql1906.MySQL1906.project_languages` pl
  WHERE
    w.repo_id = p.id
    AND p.id = pl.project_id
    AND pl.LANGUAGE = "php"
  GROUP BY
    repo_id,
    p.name
  ORDER BY
    num_stars DESC
  LIMIT
    500)
UNION DISTINCT (
  SELECT
    w.repo_id,
    p.name,
    COUNT(*) AS num_stars
  FROM
    `ghtorrentmysql1906.MySQL1906.watchers` w,
    `ghtorrentmysql1906.MySQL1906.projects` p,
    `ghtorrentmysql1906.MySQL1906.project_languages` pl
  WHERE
    w.repo_id = p.id
    AND p.id = pl.project_id
    AND pl.LANGUAGE = "ruby"
  GROUP BY
    repo_id,
    p.name
  ORDER BY
    num_stars DESC
  LIMIT
    500)
UNION DISTINCT (
  SELECT
    w.repo_id,
    p.name,
    COUNT(*) AS num_stars
  FROM
    `ghtorrentmysql1906.MySQL1906.watchers` w,
    `ghtorrentmysql1906.MySQL1906.projects` p,
    `ghtorrentmysql1906.MySQL1906.project_languages` pl
  WHERE
    w.repo_id = p.id
    AND p.id = pl.project_id
    AND (pl.LANGUAGE = "c"
      OR pl.LANGUAGE = "c++")
  GROUP BY
    repo_id,
    p.name
  ORDER BY
    num_stars DESC
  LIMIT
    500)

-- Takes the top 500 most starred repositories each in Java, JavaScript, C/C++, Python, Ruby, PHP
-- that use a "good first issue" or similar type of label for tagging issues.
-- Stored as a view called `filtered_projects` to indicate the filtered set of repositories.
SELECT
  p.repo_id
FROM
  `gfi-replication-study.gfi_dataset.initial_projects` p,
  `ghtorrentmysql1906.MySQL1906.issues` i,
  `ghtorrentmysql1906.MySQL1906.repo_labels` rl
WHERE
  p.repo_id = i.repo_id
  AND p.repo_id = rl.repo_id
  AND rl.name IN ("good first issue",
    "good-first-issue",
    "good first bug",
    "good first contribution",
    "good first task",
    "minor bug",
    "starter bug",
    "easy pick",
    "easy to fix",
    "low hanging fruit",
    "first timers only",
    "easy",
    "newbie",
    "beginner",
    "up-for-grabs",
    "help wanted")
GROUP BY
  p.repo_id
HAVING
  COUNT(*) >= 50