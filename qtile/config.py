# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
import os
import subprocess

from libqtile import bar, layout, qtile, widget, hook
from libqtile.config import Click, Drag, Match, Screen
from libqtile.lazy import lazy

from qtile_extras import widget

from globals import _MOD, _TERM
from colors.kanagawa import wave
from groups import _GROUPS
from keys import _KEYS

keys = _KEYS


# A function for toggling between MAX and MONADTALL layouts
@lazy.function
def maximize_by_switching_layout(qtile):
    current_layout_name = qtile.current_group.layout.name
    if current_layout_name == "monadtall":
        qtile.current_group.layout = "max"
    elif current_layout_name == "max":
        qtile.current_group.layout = "monadtall"


groups = _GROUPS

colors = wave
layout_theme = {
    "border_width": 2,
    "margin": 8,
    "border_focus": colors.border1,
    "border_normal": colors.border2,
}
layouts = [
    # layout.Columns(**layout_theme),
    layout.Max(
        border_width=0,
        margin=0,
    ),
    # layout.Stack(**layout_themenum_stacks=2),
    # layout.Bsp(**layout_theme),
    # layout.Matrix(**layout_theme),
    layout.MonadTall(**layout_theme),
    # layout.MonadWide(**layout_theme),
    # layout.RatioTile(**layout_theme),
    layout.Tile(
        shift_window=True,
        border_width=0,
        margin=0,
        ratio=0.335,
    ),
    # layout.TreeTab(**layout_theme),
    # layout.VerticalTile(**layout_theme),
    # layout.Zoomy(**layout_theme),
]

widget_defaults = dict(
    # font="Roboto, NotoSans Nerd Font",
    font="UbuntuMono Nerd Font",
    fontsize=16,
    padding=0,
    background=colors.bar,
    foreground=colors.text,
)
extension_defaults = widget_defaults.copy()
widgets = [
    widget.Image(
        filename="~/.config/qtile/archlinux-icon.svg", scale="False", margin_y=3
    ),
    widget.GroupBox(
        active=colors.text,
        inactive=colors.bar_bg1,
        rounded=False,
        highlight_color=colors.border2,
        highlight_method="line",
        borderwidth=0,
    ),
    widget.TextBox(
        text="| ",
        padding=2,
    ),
    widget.Prompt(foreground=colors.text),
    widget.WindowName(foreground=colors.text_special, max_chars=40),
    widget.TextBox(
        text="",
        foreground=colors.bar_bg4,
        padding=0,
        fontsize=42,
    ),
    widget.TextBox(text=" ", background=colors.bar_bg4, padding=7),
    widget.CurrentLayout(background=colors.bar_bg4),
    widget.TextBox(
        text="",
        background=colors.bar_bg4,
        foreground=colors.bar_bg3,
        padding=0,
        fontsize=42,
    ),
    widget.CPU(
        background=colors.bar_bg3,
        format="󰘚 {load_percent}% ",
        update_interval=3.0,
    ),
    widget.TextBox(
        text="",
        foreground=colors.bar_bg2,
        background=colors.bar_bg3,
        padding=0,
        fontsize=42,
    ),
    widget.Memory(
        format="{MemUsed: .0f}{mm} ",
        background=colors.bar_bg2,
        update_interval=3.0,
    ),
    # widget.DF(
    #     update_interval=60,
    #     foreground=colors[5],
    #     mouse_callbacks={
    #         "Button1": lambda: qtile.cmd_spawn(
    #             os.environ.get("TERM", "alacritty") + " -e df"
    #         )
    #     },
    #     partition="/",
    #     format="{uf}{m}({r:.0f}%)",
    #     # format="{uf}{m} free",
    #     fmt="Disk: {}",
    #     visible_on_warn=False,
    #     decorations=[
    #         BorderDecoration(
    #             colour=colors[5],
    #             border_width=[0, 0, 2, 0],
    #         )
    #     ],
    # ),
    widget.TextBox(
        text="",
        background=colors.bar_bg2,
        foreground=colors.bar_bg1,
        padding=0,
        fontsize=42,
    ),
    widget.Net(
        interface="wlan0",
        format=" {interface}: {down:.2f} ↓↑ {up:.2f} ",
        background=colors.bar_bg1,
        update_interval=3.0,
    ),
    widget.TextBox(
        text="",
        background=colors.bar_bg1,
        foreground=colors.bar_bg0,
        padding=0,
        fontsize=42,
    ),
    widget.TextBox(text="", background=colors.bar_bg0, padding=7),
    widget.Clock(
        background=colors.bar_bg0,
        format="%H:%M - %d/%m/%Y ",
        update_interval=60.0,
    ),
    widget.TextBox(
        text="",
        background=colors.bar_bg0,
        foreground=colors.bar,
        padding=0,
        fontsize=42,
    ),
    widget.UPowerWidget(
        border_colour=colors.text,
        border_charge_colour=colors.text_special,
        border_critical_colour=colors.border1,
        fill_normal=colors.text,
        fill_charge=colors.text,
        fill_low=colors.border2,
        fill_critical=colors.border1,
        foreground=colors.text,
        font_size=16,
        text_charging="↑{percentage:.0f}%",
        text_discharging="↓{percentage: .0f}%",
        margin=4,
    ),
    # widget.Battery(
    #     foreground=colors.text,
    #     format="{percent: 2.0%} ",
    # ),
    widget.ALSAWidget(
        mode="icon",
        icon_size=24,
        theme_path="/usr/share/icons/Kanagawa",
    ),
    widget.Systray(icon_size=24),
    widget.Spacer(length=8),
]
screens = [
    # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
    # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
    Screen(
        top=bar.Bar(
            widgets=widgets,
            size=28,
        ),
        # You can uncomment this variable if you see that on X11 floating resize/moving is laggy
        # By default we handle these events delayed to already improve performance, however your system might still be struggling
        # This variable is set to None (no cap) by default, but you can set it to 60 to indicate that you limit it to 60 events per second
        # x11_drag_polling_rate = 60,
    ),
]

# Drag floating layouts.
mouse = [
    Drag(
        [_MOD],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [_MOD], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([_MOD], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None


@hook.subscribe.startup_once
def start_once():
    home = os.path.expanduser("~")
    subprocess.call([home + "/.config/qtile/autostart.sh"])


# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
