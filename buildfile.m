function plan = buildfile

proj = slproject.getCurrentProjects();
isci = isempty(proj);
if isci
    proj = openProject(pwd);
else
    proj = currentProject();
end

plan = buildplan();

plan("publish") = matlab.buildtool.Task("Description","Publish", "Actions", @(~,~) local_publish(proj,isci));
plan("test")    = matlab.buildtool.Task("Description","Unit tests", "Actions", @(~,~) local_test(proj,isci));

function local_publish(proj,isci)

if isci
    quit(0)
end

function local_test(proj,isci)

if isci
    quit(0)
end

