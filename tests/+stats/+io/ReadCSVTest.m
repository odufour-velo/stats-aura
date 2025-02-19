classdef ReadCSVTest < matlab.mock.TestCase

    %% UNIT TESTS
    methods (Test)

        function testConstructor(testCase)

            % [ SETUP ]
            filename = "";

            % [ EXERCISE ]
            f = @() stats.io.ReadCSV(filename);

            % [ VERIFY ]
            testCase.verifyWarningFree(f)

        end

    end

    %% USE CASES
    methods (Test)

        function testSingleFile(testCase)

            % [ SETUP ]
            proj = currentProject();
            filename = fullfile(proj.RootFolder,"data","20250219_licences.csv");
            sut = stats.io.ReadCSV(filename);

            % [ EXERCISE ]
            read(sut)

            % [ VERIFY ]
            testCase.verifySize(sut.Data, [15870,14])

        end

    end

end