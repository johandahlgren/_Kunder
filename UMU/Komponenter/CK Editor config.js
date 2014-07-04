CKEDITOR.addStylesSet( 'my_styles',
[
    { name : 'PDF', element : 'a', attributes : { 'class' : 'pdf' } },
    { name : 'Word', element : 'a', attributes : { 'class' : 'doc' } },
    { name : 'Excel', element : 'a', attributes : { 'class' : 'xls' } },
    { name : 'PowerPoint', element : 'a', attributes : { 'class' : 'ppt' } },
    { name : 'Relaterad länk', element : 'a', attributes : { 'class' : 'columnarrow' } },
    { name : 'RSS', element : 'a', attributes : { 'class' : 'rssIcon' } },

    { name : 'Fullbredd', element : 'img', attributes : { 'class' : 'imagefullwidth',  'style' : '' } },
    { name : 'Halvbredd vänster', element : 'img', attributes : { 'class' : 'imagelefthalf', 'style' : '' } },
    { name : 'Halvbredd höger', element : 'img', attributes : { 'class' : 'imagerighthalf',  'style' : ''  } },
    { name : 'Liten bild vänster', element : 'img', attributes : { 'class' : 'imageleftsmall', 'style' : ''  } },
    { name : 'Liten bild höger', element : 'img', attributes : { 'class' : 'imagerightsmall', 'style' : ''  } }
]);

CKEDITOR.editorConfig = function( config ) {
        config.stylesSet = 'my_styles';
        config.scayt_sLang = 'sv_SE';
        config.startupOutlineBlocks = true;
        config.toolbar_Mini =
        [
            ['Bold','Italic','Link','Unlink','Image','Source']
        ];
    
        config.toolbar_Basic =
        [
            ['Bold','Italic','NumberedList','BulletedList','Link','Unlink','Image','Flash','Maximize','Format']
        ];
    
        config.toolbar_Default =
        [
            ['Cut','Copy','Paste','PasteText','-','Scayt'],
            ['Undo','Redo','-','Find','Replace','-','SelectAll','RemoveFormat'],
            ['Image','Table','SpecialChar'], 
            '/',
            ['Format','Styles'],
            ['Bold','Italic','Strike','Outdent','Indent','Subscript','Superscript'],
            ['NumberedList','BulletedList'],
            ['Link','Unlink'],
            ['Maximize','-','ShowBlocks','Source','About']
        ];
		
		config.format_tags	= 'h2;h3;p';
		config.forcePasteAsPlainText = true;
        config.skin = 'office2003';
        config.contentsCss = ['/static/trunk/css/umu_base.css','/static/trunk/css/umu_fck_special.css'];
		config.filebrowserImageBrowseUrl = '$request.contextPath/ViewContentVersion!viewAssetBrowserForFCKEditorV3.action?repositoryId=$!request.getParameter("repositoryId")&contentId=$!request.getParameter("contentId")&languageId=$!request.getParameter("languageId")&assetTypeFilter=*';
		config.filebrowserImageUploadUrl = '$request.contextPath/CreateDigitalAsset.action?contentVersionId=$!contentVersionId&useFckUploadMessages=true';
        config.filebrowserUploadUrl = '$request.contextPath/CreateDigitalAsset.action?contentVersionId=$!contentVersionId&useFckUploadMessages=true';
        config.filebrowserLinkBrowseUrl = '$request.contextPath/ViewLinkDialog!viewLinkDialogForFCKEditorV3.action?repositoryId=$!request.getParameter("repositoryId")&contentId=$!request.getParameter("contentId")&languageId=$!request.getParameter("languageId")';
        config.filebrowserLinkWindowWidth = '770';
        config.filebrowserLinkWindowHeight = '640';
};