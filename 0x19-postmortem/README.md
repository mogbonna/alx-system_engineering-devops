# Postmortem for a hypothetical web application outage:

![Flogging a dead horse](post-mortem-meetings.jpg)

## Issue Summary

- **Duration**: The outage occurred from 2:00 AM to 6:30 AM UTC on Saturday, March 9, 2024.
- **Impact**: The main web application and API services were completely unavailable during the outage. This affected approximately 85% of the user base, as they were unable to access the application or its core functionality.
- **Root Cause**: A memory leak in the application server caused the server to consume all available memory on the host, leading to the server being killed by the OOM (Out of Memory) killer.

## Timeline

- `2:00 AM UTC` - The issue was first detected by a monitoring alert indicating high memory usage on the application server.
- `2:15 AM UTC` - An on-call engineer was paged and began investigating the issue.
- `2:30 AM UTC` - The engineer restarted the application server, assuming it was a transient issue, but the memory usage continued to climb.
- `3:00 AM UTC` - The database team was brought in to investigate potential issues with the database, but no problems were found.
- `4:00 AM UTC` - The infrastructure team was engaged to look into potential host or network issues, but no issues were identified.
- `5:00 AM UTC` - The incident was escalated to the engineering manager and the entire team was brought in to investigate.
- `6:00 AM UTC` - After reviewing application logs and memory profiling, the root cause was identified as a memory leak in the application server.
- `6:30 AM UTC` - The issue was resolved by rolling out a new version of the application server with the memory leak fixed.

To better visualize the timeline of events, here's a diagram that captures the chaos:

```
+-------+  Monitoring  +-------+
|       |    Alert!    |       |
+---+---+              +---+---+
    |                      |
    | 2:00 AM              |
    |                      |
    |                      | 2:15 AM
    |                      |
    v                      v
+-------+              +-------+
|  ZZZ  |              | Invest|
| zzZZzz|              |-igate |
+---+---+              +---+---+
    |                      |
    | 2:30 AM              | 3:00 AM
    |                      |
    |                      |
    v                      v
+-------+              +-------+
| Restart|              |Database
| Server|              | Team  |
+---+---+              +---+---+
    |                      |
    |                      | 4:00 AM
    |                      |
    |                      |
    v                      v
+-------+              +-------+
| Oops! |              |Infrast|
| Still |              |-ructure|
| Leaking|              | Team  |
+---+---+              +---+---+
    |                      |
    |                      | 5:00 AM
    |                      |
    |                      |
    v                      v
+-------+              +-------+
|Escalate|              |All Hands
|  !??! |              | On Deck|
+---+---+              +---+---+
    |                      |
    | 6:00 AM              | 
    |                      |
    v                      v
+-------+              +-------+
|Memory |              |Log    |
|Profiler|              |Analysis|
+---+---+              +---+---+
    |                      |
    | 6:30 AM              |
    |                      |
    v                      v
+-------+              +-------+
| Deploy|              |         
| Fix!!|              |         
+-------+              +-------+
```

As you can see, it was a rollercoaster of events, with various teams being brought in, only to be sent back out again. But hey, at least we got a good workout in running around like headless chickens!

## Root Cause and Resolution

The root cause of the outage was a memory leak in the application server codebase. A recent refactoring of the caching mechanism introduced a subtle bug that caused the application server to continuously allocate memory without releasing it, eventually consuming all available memory on the host.

To resolve the issue, the team reverted the recent changes to the caching mechanism and deployed a new version of the application server with the memory leak fixed. This allowed the application server to run without continuously consuming memory, resolving the outage.

## Corrective and Preventative Measures

While the specific memory leak issue was resolved, there are several areas for improvement to prevent similar issues in the future:

- **Improved Testing**: More thorough testing, including load testing and memory profiling, should be implemented for major application changes to catch potential memory leaks or performance issues before deployment.
- **Monitoring Enhancements**: Additional monitoring should be set up to track application-level memory usage and provide earlier warnings of potential memory leaks or other resource exhaustion issues.
- **Incident Response Improvements**: The incident response process should be reviewed and improved, with clearer escalation paths and better coordination between teams to more efficiently diagnose and resolve issues.

Specific tasks to address these areas:

- Implement load testing and memory profiling as part of the CI/CD pipeline.
- Add application-level memory usage monitoring and alerting.
- Document and train teams on an updated incident response process.
- Conduct a retrospective to identify areas for improvement in communication and coordination during incidents.
