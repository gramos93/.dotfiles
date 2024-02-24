from libqtile import qtile
from libqtile.config import Key
from libqtile.lazy import lazy

from globals import _MOD, _TERM

_KEYS = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([_MOD], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([_MOD], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([_MOD], "j", lazy.layout.down(), desc="Move focus down"),
    Key([_MOD], "k", lazy.layout.up(), desc="Move focus up"),
    Key([_MOD], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key(
        [_MOD, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"
    ),
    Key(
        [_MOD, "shift"],
        "l",
        lazy.layout.shuffle_right(),
        desc="Move window to the right",
    ),
    Key([_MOD, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([_MOD, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key(
        [_MOD, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"
    ),
    Key(
        [_MOD, "control"],
        "l",
        lazy.layout.grow_right(),
        desc="Grow window to the right",
    ),
    Key([_MOD, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([_MOD, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([_MOD], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [_MOD, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([_MOD], "Return", lazy.spawn(_TERM), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([_MOD], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([_MOD], "w", lazy.window.kill(), desc="Kill focused window"),
    Key(
        [_MOD],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window",
    ),
    Key(
        [_MOD],
        "t",
        lazy.window.toggle_floating(),
        desc="Toggle floating on the focused window",
    ),
    Key([_MOD, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([_MOD, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    # Key([_MOD], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    Key(
        [_MOD],
        "r",
        lazy.spawn("rofi -show drun"),
        desc="Spawn a command using a prompt widget",
    ),
]

# Add key bindings to switch VTs in Wayland.
# We can't check qtile.core.name in default config as it is loaded before qtile is started
# We therefore defer the check until the key binding is run by using .when(func=...)
for vt in range(1, 8):
    _KEYS.append(
        Key(
            ["control", "mod1"],
            f"f{vt}",
            lazy.core.change_vt(vt).when(func=lambda: qtile.core.name == "wayland"),
            desc=f"Switch to VT{vt}",
        )
    )

# Volume KeyBinds
_KEYS.extend(
    (
        Key(
            [],
            "XF86AudioLowerVolume",
            lazy.spawn("amixer sset Master 5%-"),
            desc="Lower Volume by 5%",
        ),
        Key(
            [],
            "XF86AudioRaiseVolume",
            lazy.spawn("amixer sset Master 5%+"),
            desc="Raise Volume by 5%",
        ),
        Key(
            [],
            "XF86AudioMute",
            lazy.spawn("amixer sset Master 1+ toggle"),
            desc="Mute/Unmute Volume",
        ),
    )
)

__all__ = ["_KEYS"]
