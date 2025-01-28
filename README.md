# Bash

My bash library.

## Example

```bash
#!/bin/bash -eu

. <(curl -L https://github.com/ogiekako/bash/raw/refs/heads/main/lib.sh)

str::snake_to_camel foo_bar # fooBar
echo foo_bar | str::snake_to_camel # fooBar
```

## References

* https://www.gnu.org/software/bash/manual/bash.html
