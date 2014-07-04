<div id="mainContentContainer" class="fullPage">
	<div class="innerContainer">
		<a id="content"></a>
		<div id="breadcrumbs">
			<ig:slot id="crumbtrail" inherit="true" allowedComponentNames="Smulnavigering" allowedNumberOfComponents="1"></ig:slot>
		</div>
		<ig:slot id="main" inherit="false" allowedComponentGroupNames="MainColumn"></ig:slot>
	</div>
</div>