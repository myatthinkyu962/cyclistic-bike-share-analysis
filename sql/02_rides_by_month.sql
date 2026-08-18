-- PROCESS STEP 2: Check the twelve months are all present and complete.
-- Expect twelve rows, June 2025 to May 2026, with no month missing
-- or unusually small.
SELECT
  FORMAT_TIMESTAMP('%Y-%m', started_at) AS month,
  COUNT(*) AS rides
FROM `cyclistic.trips`
GROUP BY month
ORDER BY month;
