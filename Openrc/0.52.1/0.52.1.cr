class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super
    end

    def configure
        super

        runMesonCommand([   "setup",
                            "--reconfigure",
                            @buildDirectoryNames["MainBuild"],"-Dsysvinit=true"],
                            mainWorkDirectoryPath)
    end

    def build
        super

        runMesonCommand([   "compile"],
                            buildDirectoryPath)
    end

    def prepareInstallation
        super

        runMesonCommand([   "install"],
                            buildDirectoryPath,
                            {"DESTDIR" => "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}"})

        makeDirectory("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}sbin")

        (1..6).each do |value|
            makeLink("agetty","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}etc/init.d/agetty.tty#{value}",:symbolicLink)
        end

        makeLink("openrc-init","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}sbin/init",:symbolicLink)
    end

    def install
        super

        (1..6).each do |value|
            runRcUpdateCommand(["add","agetty.tty#{value}","default"])
        end
    end

end
