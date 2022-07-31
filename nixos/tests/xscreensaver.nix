import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "pass-secret-service";
  meta.maintainers = with lib; [ aidalgol ];

  nodes.machine = { nodes, pkgs, ... }:
    {
      imports = [ ./common/x11.nix ./common/user-account.nix ];
      test-support.displayManager.auto.user = "alice";
      services.xscreensaver.enable = true;
    };

  testScript = ''
    machine.wait_for_x()
    machine.wait_for_unit("xscreensaver", "alice")

    _, output = machine.systemctl("status xscreensaver", "alice")
    assert 'To prevent the kernel from randomly unlocking' not in output
    assert 'your screen via the out-of-memory-killer' not in output
    assert '"xscreensaver-auth" must be setuid root' not in output
  '';
})
