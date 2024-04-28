#!/bin/bash

sudo dnf install cronie -y
sudo systemctl enable crond.service
sudo systemctl start crond.service
sudo systemctl status crond
