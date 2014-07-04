<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="infoglue-content" prefix="content" %>
<%@ taglib uri="infoglue-structure" prefix="structure" %>

<structure:boundPage id="contactPage" propertyName="KontaktaOss"/>

<structure:componentPropertyValue id="postAddress" propertyName="Postadress" />
<structure:componentPropertyValue id="besoksAddress" propertyName="Besoksadress" />
<structure:componentPropertyValue id="phone" propertyName="Telefon" />
<structure:componentPropertyValue id="fax" propertyName="Fax" />
<structure:componentPropertyValue id="email" propertyName="Epost" />

<structure:componentLabel mapKeyName="Postadress"/>: <c:out value="${postAddress}" /><br />
<structure:componentLabel mapKeyName="Besoksadress"/>: <c:out value="${besoksAddress}" /><br />
<structure:componentLabel mapKeyName="Telefon"/>: <c:out value="${phone}" /><br />
<structure:componentLabel mapKeyName="Fax"/>: <c:out value="${fax}" /><br />
<structure:componentLabel mapKeyName="Epost"/>: <c:out value="${email}" /><br />

<a href="<c:out value="${contactPage.url }" />"><structure:componentLabel mapKeyName="KontaktaOss"/><img class="puffArrow" src=""/></a>
