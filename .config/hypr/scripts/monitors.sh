#!/bin/bash

active_monitor_id=$(hyprctl activeworkspace | grep "monitorID" | awk '{print $2}')
