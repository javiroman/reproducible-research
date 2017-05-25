YAML How-To
-----------

[YAML main site](http://www.yaml.org)

YAML's markup can use whitespace to indicate scoping of items. Tabs are not
allowed, so there is no chance for confusion about indention level. 

YAML constructs such as mappings, sequences, and scalars all mesh nicely with 
existing Python data types like dictionaries, lists, strings, and integers. 

- Example YAML vs Python

 YAML - mapping
```
name: Jesse
```

 Python - dictionary (key:value)
```
{'name': 'Jesse'}
```

- More complex example:

```
object:
    attributes:
        - attr1
        - attr2
        - attr3
    methods: [ getter, setter ]
```

A a top-level entity named "object". This "object" has two block mappings:
"attributes" and "methods". The "attributes" mapping uses the a verbose
YAML syntax for a list. The "methods" mapping is a list also, in a compact
syntax. YAML's syntax has two ways of achieving the same intended goal. There
is the verbose, multi-line method, and the more compact method.

In Python terminology this document is a dictionary with a key "object", and a
"value" made of a another dictionary with a key "attributes" with value "a list",
and a key "methods" with value other list:

Python
```
{'object': {'attributes': ['attr1', 'attr2', 'attr3'], 'methods': ['getter', 'setter']}}
```

- Strings do not require quotation:
```
sonnet: |
    I wish I could
    write a poem
    but I can't
```

This is a YAML document with a mapping, a dictionary with a key "sonnet" with a
string as value. In Python we get this dict:

Python
```
{'sonnet': "I wish I could\nwrite a poem\nbut I can't\n"}
```

Note that Trailing and preceding whitespace is trimmed out in the basic use
case of ''|''.

- YAML documents:

Core to YAML is the concept of documents. A document is not just a separate
file in this case. Instead, think of a document as just a chunk of YAML. You
can have multiple documents in a single stream of YAML, if each one is
separated by ''---'', like:

```
---
document: this is doc 1
---
document: this is doc 2
```

- YAML also supports variables:
```
some_thing: &NAME foobar
other_thing: * NAME
```

Parses to (Python):
```
{'other_thing': 'foobar', 'some_thing': 'foobar'}
```

- Terminology

YAML’s block collections: use indentation for scope and begin each entry on its
own line. 

Block sequences (lists) indicate each entry with a dash and space (“- ”).

Mappings (dictionary or hash) use a colon and space (“: ”) to mark each key: value pair. 

Comments begin with an octothorpe (also called a “hash”, “sharp”, “pound”, or
“number sign” - “#”).

YAML also has flow styles, using explicit indicators rather than indentation to
denote scope. The flow sequence is written as a comma separated list within
square brackets. In a similar manner, the flow mapping uses curly braces.

Sequence of Sequences:
```
- [name        , hr, avg  ]
- [Mark McGwire, 65, 0.278]
- [Sammy Sosa  , 63, 0.288]
```

Mapping of Mappings:
```
Mark McGwire: {hr: 65, avg: 0.278}
Sammy Sosa: {
    hr: 63,
    avg: 0.288
}
```

YAML uses three dashes (“---”) to separate directives from document content.
This also serves to signal the start of a document if no directives are
present. Three dots ( “...” ) indicate the end of a document without starting a
new one, for use in communication channels.

Repeated nodes (objects) are first identified by an anchor (marked with the
ampersand - “&”), and are then aliased (referenced with an asterisk - “*”)
thereafter.





