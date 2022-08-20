@version 2.8
@warnings
@script modeler
@name SK_ImageReplacer

image_array;
target_image;
c1, c2, c3;

main
{
    init_image_array();
    
    reqbegin("SK_ImageReplacer rev.0.1");
    
    c1 = ctllistbox("Loaded Image", 500, 300, "lb_count", "lb_name", "lb_event");
    c2 = ctlfilename("Full Path", "", 100, 20);
    c3 = ctlbutton("Replace", 100, "replace_button");
    c4 = ctltext("Note :", "The Ok and Cancel buttons at the bottom both just close the window.");
    
    c2.active(false);
    c3.active(false);
    
    reqpost();
    reqend();
}

init_image_array
{
    image_array = nil;
    
    // get first image
    
	img = Image();
	
	while(img)
	{
        image_array += img;
		img = img.next();
	}
}

lb_count
{
    return(image_array.count());
}

lb_name: index
{
    return(image_array[index].filename(0));
}

lb_event: items
{
    if(items.count() != 1)
    {
        target_image = nil;
        
        setvalue(c2, "");
        
        c2.active(false);
        c3.active(false);
        
        return;
    }
    
    target_image = image_array[items[1]];
    setvalue(c2, image_array[items[1]].filename(0));
    
    c2.active(true);
    c3.active(true);
}

imageexists: fname
{
    for(i = 1; i <= image_array.count(); i++)
    {
        if(image_array[i].filename(0) == fname)
            return(true);
    }
    return(false);
}

replace_button
{
    filename = getvalue(c2);
    
    if(!fileexists(filename) || imageexists(filename))
    {
        return;
    }

    target_image.replace(filename);
    init_image_array();
    requpdate();
}
