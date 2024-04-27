class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super
    end

    def configure
        super

        runMesonCommand([   "setup",
                            "--reconfigure",
                            "-Dauto_features=disabled",
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

    end

    def install
        super

        (1..6).each do |value|
            makeLink("agetty","#{Ism.settings.rootPath}etc/init.d/agetty.tty#{value}",:symbolicLink)
            runRcUpdateCommand(["add","agetty.tty#{value}","default"])
        end

        makeLink("openrc-init","#{Ism.settings.rootPath}sbin/init",:symbolicLink)
    end

end
