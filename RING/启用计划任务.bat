schtasks /create /xml "C:/RING/tasks/OnClass.xml" /tn "\TASK-RING\OnClass" /RU "%USERNAME%"
schtasks /create /xml "C:/RING/tasks/OffClass.xml" /tn "\TASK-RING\OffClass" /RU "%USERNAME%"
pause