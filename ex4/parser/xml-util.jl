using EzXML

function init(file)
    doc = XMLDocument()
    node = ElementNode("tokens")
    setroot!(doc,node)
    save(file,doc)
end

function save(file,doc)
    write("$(file)T.xml",doc)
end

function addToken(name,value,file)
    doc = EzXML.readxml("$(file)T.xml")
    node = ElementNode(name)
    node.content = value
    link!(doc.root,node)
    save(file,doc)
end

function addChild(name, value)
    node = ElementNode(name)
    node.content = value
    return node
end

function linkToParent(parent,child)
    link!(parent,child)
    return parent
end
