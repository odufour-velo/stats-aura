classdef ReadCSV < matlab.mixin.SetGet

    %% CONSTANT PROPERTIES
    properties (Constant)
        REQUIRED_COLUMNS = ["Age"; "Sexe"; "Dept_Cod"; "Club_Nom"; "Saison"; "Region_Code"; "Categorie"; "Discipline"];
    end

    %% DEPENDENT PROPERTIES
    properties (Dependent)
        Data
    end

    %% PRIVATE PROPERTIES
    properties (Access = private)
        data_                       table
    end

    %% IMMUTABLE PROPERTIES
    properties (SetAccess = immutable, GetAccess = private)
        filename_       (1,1)       string
    end

    %% CONSTRUCTOR
    methods

        function obj = ReadCSV(filename,varargin)
            obj.filename_ = filename;
            if ~isempty(varargin)
                set(obj,varargin{:})
            end
        end

    end

    %% ACCESSORS
    methods

        function data = get.Data(obj)
            data = obj.data_;
        end

    end

    %% PUBLIC METHODS
    methods

        function read(obj)

            % Read CSV as a table and check that all required variables are present
            d = readtable(obj.filename_);
            assert(all(ismember(obj.REQUIRED_COLUMNS, d.Properties.VariableNames)), ...
                "stats:invalidFormat", "CSV file shall contains at least columns: (%s)", ...
                strjoin(obj.REQUIRED_COLUMNS,','))

            % Remove extra characters
            d{:,:} = regexprep(d{:,:}, "[=""]", "");

            d.Age           = str2double(d.Age);
            d.Sexe          = categorical(d.Sexe);
            d.Dept_Cod      = str2double(d.Dept_Cod);
            d.Region_Code   = str2double(d.Region_Code);
            d.Saison        = str2double(d.Saison);
            d.Categorie     = categorical(d.Categorie);
            d.Discipline    = categorical(d.Discipline);
            d.Club_Nom      = string(d.Club_Nom);

            obj.data_ = d;

        end

    end

end