<div id="mainContentContainer" class="widePage">
	<div class="innerContainer">
		<a id="content"></a>
		<div id="navColContainer">
			<div class="innerContainer">
				<ig:slot id="left" allowedComponentGroupNames="Navigation"></ig:slot>
			</div>
		</div>
		<div id="mainColContainer">
			<div class="innerContainer">
				<div id="breadcrumbs">
					<ig:slot id="crumbtrail" inherit="true" allowedComponentNames="Smulnavigering"></ig:slot>
				</div>
				<ig:slot id="main" inherit="false" allowedComponentGroupNames="MainColumn"></ig:slot>
			</div>
		</div>
	</div>
</div>