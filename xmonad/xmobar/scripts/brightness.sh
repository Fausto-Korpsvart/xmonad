#!/bin/bash

(( br = $(brightnessctl get) * 100 / 255 ))

 echo -n "$br%"
