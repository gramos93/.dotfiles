from libqtile.config import Group, Key
from libqtile.lazy import lazy

from globals import _MOD
from keys import _KEYS

keys = _KEYS

_GROUPS = []
group_names = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    # "8",
    # "9",
]
group_labels = [
    "   ",
    "   ",
    " 󰌠  ",
    "   ",
    "   ",
    "   ",
    "   ",
    # "8",
    # "9",
]
group_layouts = [
    "monadtall",
    "monadtall",
    "tile",
    "tile",
    "monadtall",
    "monadtall",
    "monadtall",
    # "monadtall",
    # "monadtall",
]


for name, label, glayout in zip(group_names, group_labels, group_layouts):
    _GROUPS.append(
        Group(
            name=name,
            layout=glayout,
            label=label,
        )
    )

for i in _GROUPS:
    keys.extend(
        [
            # mod1 + group number = switch to group
            Key(
                [_MOD],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod1 + shift + group number = switch to & move focused window to group
            Key(
                [_MOD, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod1 + shift + group number = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )

__all__ = ["_GROUPS"]
