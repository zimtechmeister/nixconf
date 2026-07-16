local nix = require("nix")

-- TODO: dont use this with uwsm

hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")

hl.env("NIXOS_OZONE_WL", "1");

if nix.cursor then
    hl.env("XCURSOR_THEME", nix.cursor.name)
    hl.env("XCURSOR_SIZE", nix.cursor.size)

    hl.env("HYPRCURSOR_THEME", nix.cursor.name)
    hl.env("HYPRCURSOR_SIZE", nix.cursor.size)
end
