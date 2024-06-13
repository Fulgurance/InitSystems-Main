class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super
    end

    def configure
        super

        runMesonCommand(arguments:  "setup --reconfigure                \
                                    #{@buildDirectoryNames["MainBuild"]}\
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

        (1..6).each do |value|
            makeLink(   target: "agetty",
                        path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/init.d/agetty.tty#{value}",
                        type:   :symbolicLink)
        end

        makeLink(   target: "openrc-init",
                    path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}sbin/init",
                    type:   :symbolicLink)
    end

    def install
        super

        (1..6).each do |value|
            runRcUpdateCommand(arguments:   "add agetty.tty#{value} default")
        end
    end

end
