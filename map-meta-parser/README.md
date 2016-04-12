# map-meta-parser
This resource extracts meta information for each map file and keeps it in memory.

## Exports

> `boolean|table` **getMapMeta** ( `string|resource` map )
> ```lua
> return {
>     info = { ... },
>     maps = { ... },
>     files = { ... },
>     scripts = { ... },
>     includes = { ... },
>     settings = { ... }
> }
> ```

> `boolean|table` **getMapMetaInfo** ( `string|resource` map )
> ```lua
> return {
>     name = false|string,
>     author = false|string,
>     type = false|string,
>     version = false|string,
>     description = false|string,
>     ...
> }
> ```

> `boolean|table` **getMapMetaFiles** ( `string|resource` map )
> ```lua
> return {
>     [n] = {
>         src = {
>             absolute = string,
>             relative = string,
>             hash = string,
>         }
>     }
> }
> ```

> `boolean|table` **getMapMetaScripts** ( `string|resource` map )
> ```lua
> return {
>     [n] = {
>         src = {
>             absolute = string,
>             relative = string,
>             hash = string,
>         },
>         type = "client"|"server"|"shared"
>     }
> }
> ```

> `boolean|table` **getMapMetaIncludes** ( `string|resource` map )
> ```lua
> return {
>     [n] = {
>         resource = string
>     }
> }
> ```

> `boolean|table` **getMapMetaSettings** ( `string|resource` map )
> ```lua
> return {
>     [n] = {
>         access = "public"|"protected"|"private",
>         name = string,
>         value = string,
>     }
> }
> ```

> `boolean|table` **getMapMetaMaps** ( `string|resource` map )
> ```lua
> return {
>     [n] = {
>         src = {
>             absolute = string,
>             relative = string,
>             hash = string,
>         }
>     }
> }
> ```
