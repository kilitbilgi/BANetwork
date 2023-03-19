# BANetwork

BANetwork is package help developers to make requests easily.

## Install

Via SPM, add new package, search url below
```bash
https://github.com/kilitbilgi/BANetwork
```

## Basic Usage

- Create plist file called BAConfig
- Add these keys
```bash
baseURL (String)(without http(s))
isLogEnabled (Bool)
timeout (Number)
```
- Build a request via builder
```bash
let endpoint = BAEndpoint()
            .set(method: .get)
            .set(path: "")
            .add(header: BAHeaderModel(field: "id", value: "1"))
            .add(header: BAHeaderModel(field: "auth", value: "1"))
            .add(queryItem: BAQueryModel(name: "city", value: "izmir"))
            .add(queryItem: BAQueryModel(name: "cocktail", value: "long-island"))
            .build()
```

- Make request!
```bash
network.request(to: endpoint) { (r: BaseResult<ProductResponse?, Error>) in
            switch r {
            case let .success(r):
                guard let response = r else {
                    return
                }
                completion?(response)
            case let .failure(error):
                failure?(error)
            }
        }
```

## Example Project

https://github.com/kilitbilgi/BANetworkSample

## License

 * MIT license ([LICENSE-MIT](LICENSE-MIT) or http://opensource.org/licenses/MIT)

