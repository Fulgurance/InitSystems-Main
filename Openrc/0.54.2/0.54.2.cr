class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super
    end

    def configure
        super

        runMesonCommand(arguments:  "setup --reconfigure                    \
                                    #{@buildDirectoryNames["MainBuild"]}    \
                                    -Dsysvinit=true",
                        path:       mainWorkDirectoryPath)
    end

    def build
        super

        runMesonCommand(arguments:  "compile",
                        path:       buildDirectoryPath)
    end

    def prepareInstallation
        super

        runMesonCommand(arguments:      "install",
                        path:           buildDirectoryPath,
                        environment:    {"DESTDIR" => "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}"})

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}sbin")

        makeLink(   target: "openrc-init",
                    path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}sbin/init",
                    type:   :symbolicLinkByOverwrite)
    end

    def install
        super

        (1..6).each do |value|
            runRcUpdateCommand(arguments:   "add agetty.tty#{value} default")
        end
    end

end
