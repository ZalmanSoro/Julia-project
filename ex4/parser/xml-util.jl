using EzXML

function init(file)
    doc = XMLDocument()
    node = ElementNode("tokens")
    setroot!(doc,node)
    save(file,doc)
end

function save(file,doc)
    write("./$(file).xml",doc)
end

function addToken(name,value,file)
    doc = EzXML.readxml("./$(file).xml")
    node = ElementNode(name)
    node.content = value
    link!(doc.root,node)
    save(file,doc)
end
