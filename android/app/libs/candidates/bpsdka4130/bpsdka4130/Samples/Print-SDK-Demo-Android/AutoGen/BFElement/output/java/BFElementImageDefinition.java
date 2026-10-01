package com.brother.bfelement;

public class BFElementImageDefinition {

public class ImageBlueEnhancement {
    public static final String key = "ImageBlueEnhancement";
}

public class ImageBrightness {
    public static final String key = "ImageBrightness";
}

public class ImageContrast {
    public static final String key = "ImageContrast";
}

public class ImageGreenEnhancement {
    public static final String key = "ImageGreenEnhancement";
}

public enum ImageHalftone {
    SimpleThreshold,    
    Dither,    
    ErrorDiffusion,    
    __Null;    

    public static final String key = "ImageHalftone";
}


public enum ImageOrientation {
    Portrait,    
    Landscape,    
    __Null;    

    public static final String key = "ImageOrientation";
}


public class ImageRedEnhancement {
    public static final String key = "ImageRedEnhancement";
}

public class ImageTrimBlankDataFromTail {
    public static final String key = "ImageTrimBlankDataFromTail";
}

}