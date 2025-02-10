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

scripts = dir(fullfile(proj.RootFolder,"*.mlx"));
for i = 1:numel(scripts)
    scriptname = fullfile(scripts(i).folder,scripts(i).name);
    reportname = regexprep(scriptname, "\.mlx$", ".pdf");
    fprintf(1,"## Export '%s' into '%s'\n",scriptname, reportname);
    export(scriptname,reportname,"Format", "pdf");
end

if isci
    quit(0)
end

function local_test(proj,isci)

if isci
    quit(0)
end

