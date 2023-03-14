class Target < ISM::Software

    def extract
        super

        moveFile("#{workDirectoryPath(false)}/openrc-0.46","#{workDirectoryPath(false)}/0.46")
    end

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
