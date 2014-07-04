//
//  Shader.fsh
//  Testprojekt
//
//  Created by Johan Dahlgren on 11/1/13.
//  Copyright (c) 2013 Johan Dahlgren. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
