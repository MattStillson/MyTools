CREATE TABLE #enum_job
  (
    Job_ID uniqueidentifier,
    Last_Run_Date         INT,
    Last_Run_Time         INT,
    Next_Run_Date         INT,
    Next_Run_Time         INT,
    Next_Run_Schedule_ID  INT,
    Requested_To_Run      INT,
    Request_Source        INT,
    Request_Source_ID     VARCHAR(100),
    Running               INT,
    Current_Step          INT,
    Current_Retry_Attempt INT,
    State                 INT
  )


INSERT INTO
  #enum_job EXEC master.dbo.xp_sqlagent_enum_jobs 1,  garbage


SELECT
  R.name ,
  R.last_run_date,
  R.RunningForTime,
  GETDATE()AS now
FROM
  #enum_job a
INNER JOIN
  (
    SELECT
      j.name,
      J.JOB_ID,
      ja.run_requested_date AS last_run_date,
      (DATEDIFF(mi,ja.run_requested_date,GETDATE())) AS RunningFor,
      CASE LEN(CONVERT(VARCHAR(5),DATEDIFF(MI,JA.RUN_REQUESTED_DATE,GETDATE())/60))
        WHEN 1 THEN '0' + CONVERT(VARCHAR(5),DATEDIFF(mi,ja.run_requested_date,GETDATE())/60)
        ELSE CONVERT(VARCHAR(5),DATEDIFF(mi,ja.run_requested_date,GETDATE())/60)
      END
      + ':' +
      CASE LEN(CONVERT(VARCHAR(5),(DATEDIFF(MI,JA.RUN_REQUESTED_DATE,GETDATE())%60)))
        WHEN 1 THEN '0'+CONVERT(VARCHAR(5),(DATEDIFF(mi,ja.run_requested_date,GETDATE())%60))
        ELSE CONVERT(VARCHAR(5),(DATEDIFF(mi,ja.run_requested_date,GETDATE())%60))
      END
      + ':' +
      CASE LEN(CONVERT(VARCHAR(5),(DATEDIFF(SS,JA.RUN_REQUESTED_DATE,GETDATE())%60)))
        WHEN 1 THEN '0'+CONVERT(VARCHAR(5),(DATEDIFF(ss,ja.run_requested_date,GETDATE())%60))
        ELSE CONVERT(VARCHAR(5),(DATEDIFF(ss,ja.run_requested_date,GETDATE())%60))
      END AS RunningForTime
    FROM
      msdb.dbo.sysjobactivity AS ja
    LEFT OUTER JOIN msdb.dbo.sysjobhistory AS jh
    ON
      ja.job_history_id = jh.instance_id
    INNER JOIN msdb.dbo.sysjobs_view AS j
    ON
      ja.job_id = j.job_id
    WHERE
      (
        ja.session_id =
        (
          SELECT
            MAX(session_id) AS EXPR1
          FROM
            msdb.dbo.sysjobactivity
        )
      )
  )
  R ON R.job_id = a.Job_Id
AND a.Running   = 1
DROP TABLE #enum_job