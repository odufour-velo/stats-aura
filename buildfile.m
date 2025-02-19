function plan = buildfile

proj = slproject.getCurrentProjects();
isci = isempty(proj);
if isci
    proj = openProject(pwd);
else
    proj = currentProject();
end

plan = buildplan();

plan("check")   = matlab.buildtool.Task("Description","Code Analyzer",  "Actions", @(~,~) local_check(proj,isci));
plan("publish") = matlab.buildtool.Task("Description","Publish",        "Actions", @(~,~) local_publish(proj,isci));
plan("test")    = matlab.buildtool.Task("Description","Unit tests",     "Actions", @(~,~) local_test(proj,isci));

function local_check(proj,isci)
%
% Check MATLAB code syntax (Code Analyzer)
%

% Take only .m and .mlx from project
files = vertcat(proj.Files.Path);
[~,~,ext] = fileparts(files);
files = files(ismember(ext,[".m",".mlx"]));

% Identify code issues
issues = codeIssues(files);

% Format the output result
outStr = formattedDisplayText(issues.Issues(:,["Location" "Severity" "Description"]));

if isci
    disp(outStr)
    quit(~isempty(issues.Issues))
else
    % Assert there is no issue
    assert(isempty(issues.Issues),outStr)
end

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
%
% Create test suite and generate JUnit report in CI context
%

runner = matlab.unittest.TestRunner.withTextOutput();

% Enable the JUnit XML report for GitLab CI
if isci
    xmlFile = fullfile(proj.RootFolder, "TestResults.xml");
    plugin = matlab.unittest.plugins.XMLPlugin.producingJUnitFormat(xmlFile);
    runner.addPlugin(plugin)
else
    pdfFile = fullfile(proj.RootFolder, "TestReport.pdf");
    plugin = matlab.unittest.plugins.TestReportPlugin.producingPDF(pdfFile);
    runner.addPlugin(plugin)
end

ts = matlab.unittest.TestSuite.fromProject(proj);

results = runner.run(ts);

restable = table(results);
restable.Name = string(restable.Name);
restable.Duration = seconds(restable.Duration);
disp(restable(:,["Name","Passed","Failed","Incomplete","Duration"]))

if isci
    quit(nnz([results.Failed]))
else
    assertSuccess(results);
end

