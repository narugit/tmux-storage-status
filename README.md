# tmux-storage-status
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/narugit/tmux-storage-status/blob/master/LICENSE)

This plugin is a tmux plugin to monitor storage usage.

![preview](https://user-images.githubusercontent.com/28133383/104154264-d5103900-5427-11eb-9291-590bd1935aad.png)

## Installation
1. Add my plugin to the list of tpm plugins in your `.tmux.conf`.

    ```shell
    set -g @plugin 'narugit/tmux-storage-status'
    ```

1. <kbd>prefix</kbd>+<kbd>I</kbd> to fetch the plugin and source it.

## Usage
Add any of the supported format strings to the `status-right` tmux option.

```shell
set -g status-right 'Storage: #{storage_status}'
```

### Default
Default output is available storage, `12G/512G`.

### Customize Output
To customize the output, please change `storage_view_tmpl`.

If you want to output `(SSD)free: 60G | used: 452G | total: 512G`, set like below.

```shell
set -g @storage_view_tmpl '(SSD)#[fg=#{storage.color}]free: #{storage.free} | used: #{storage.used} | total: #{storage.total}'
```

### Supported variable
- `#{storage.color}`: main storage metric color
- `#{storage.free}`: free storage size
- `#{storage.pfree}`: free storage percentage
- `#{storage.used}`: used storage size
- `#{storage.pused}`: used storage percentage
- `#{storage.total}`: total storage size
