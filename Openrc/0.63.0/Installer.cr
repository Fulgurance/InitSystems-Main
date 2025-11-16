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

        inittabData = <<-CODE
        id:3:initdefault:

        si::sysinit:/sbin/openrc sysinit

        rc::bootwait:/sbin/openrc boot

        l0u:0:wait:/sbin/telinit u
        l0:0:wait:/sbin/openrc shutdown
        l0s:0:wait:/sbin/halt.sh
        l1:1:wait:/sbin/openrc single
        l2:2:wait:/sbin/openrc nonetwork
        l3:3:wait:/sbin/openrc default
        l4:4:wait:/sbin/openrc default
        l5:5:wait:/sbin/openrc default
        l6u:6:wait:/sbin/telinit u
        l6:6:wait:/sbin/openrc reboot
        l6r:6:wait:/sbin/reboot -dkn

        su0:S:wait:/sbin/openrc single
        su1:S:wait:/sbin/sulogin

        c1:12345:respawn:/sbin/agetty --noclear 38400 tty1 linux
        c2:2345:respawn:/sbin/agetty 38400 tty2 linux
        c3:2345:respawn:/sbin/agetty 38400 tty3 linux
        c4:2345:respawn:/sbin/agetty 38400 tty4 linux
        c5:2345:respawn:/sbin/agetty 38400 tty5 linux
        c6:2345:respawn:/sbin/agetty 38400 tty6 linux

        ca:12345:ctrlaltdel:/sbin/shutdown -r now

        x:a:once:/usr/bin/startDM

        CODE
        fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/inittab",inittabData)
    end

end
