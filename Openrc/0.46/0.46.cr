class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super

        runMesonCommand(["setup","build"],mainWorkDirectoryPath)
    end

    def build
        super

        runMesonCommand(["compile"],buildDirectoryPath)
    end

    def prepareInstallation
        super

        runMesonCommand(["install"],buildDirectoryPath,
                                    {"DESTDIR" => "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}"})
    end

end
