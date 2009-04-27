package WebGUI::Form::Control;

=head1 LEGAL

 -------------------------------------------------------------------
  WebGUI is Copyright 2001-2009 Plain Black Corporation.
 -------------------------------------------------------------------
  Please read the legal notices (docs/legal.txt) and the license
  (docs/license.txt) that came with this distribution before using
  this software.
 -------------------------------------------------------------------
  http://www.plainblack.com                     info@plainblack.com
 -------------------------------------------------------------------

=cut

use strict;
use WebGUI::International;

=head1 NAME

Package WebGUI::Form::Control

=head1 DESCRIPTION

Base class for all form field objects. Never use this class directly.

=head1 SYNOPSIS

 use base 'WebGUI::Form::Control';

 ...your methods here...

Subclasses will look like this:

 use WebGUI::Form::subclass;
 my $obj = WebGUI::Form::subclass->new($session,%params);

 my $html = $obj->toHtml;
 my $html = $obj->toHtmlAsHidden;
 my $tableRows = $obj->toHtmlWithWrapper;

 my $value = $obj->getValue;
 my $value = $obj->getDefaultValue;
 my $html = $obj->getValueAsHtml;


=head1 METHODS 

The following methods are available via this package.

=cut


#-------------------------------------------------------------------

=head2 areOptionsSettable ( )

Returns a boolean indicating whether the options of the list are settable. Some have a predefined set of options. This is useful in generating dynamic forms. Really only used by form controls with an "options" field, which are mostly subclasses if WebGUI::Form::List. Returns 0.

=cut

sub areOptionsSettable {
    return 1;
}

#-------------------------------------------------------------------

=head2 definition ( session, [ additionalTerms ] )

Defines passible parameters for a form field.

=head3 session

The session object, usually for internationalization.

=head3 additionalTerms

An array reference containing a hash of hashes of parameter names and their definitions.

Example: 

  [{
     myParam=>{
	defaultValue=>undef
    	}
	}]

By default all form fields have the following parameters:

=head4 name

The field name.

=head4 value

The starting value for the field.

=head4 defaultValue

If no starting value is specified, this will be used instead.

=head4 _defaulted

This flag indicates that the defaultValue was used.  It is used by Form types that support
an initial blank field, instead of using a default, like WebGUI::Form::Date

=head4 extras

Add extra attributes to the form tag like 

  onmouseover='doSomething()'

=head4 label

A text label that will be displayed if toHtmlWithWrapper() is called.

=head4 id

A unique identifier that can be used to identify this field with javascripts and cascading style sheets. Is autogenerated if not specified. The autogenerated version is the value of the name parameter concatinated with the string "_formId". So for a field called "title" it would be "title_formId".

=head4 idPrefix

If specified, this will be prepended to the id (whether autogenerated or not) to prevent overlap of two similar forms on the same page.

=head4 uiLevel

The UI Level that the user must meet or exceed if this field should be displayed with toHtmlWithWrapper() is called.

=head4 subtext

A text string that will be appended after the field when toHtmlWithWrapper() is called.

=head4 labelClass

A stylesheet class assigned to the label with toHtmlWithWrapper() is called. Defaults to "formDescription".

=head4 fieldClass

A stylesheet class assigned to wrapper the field when toHtmlWithWrapper() is called. Defaults to "tableData".

=head4 rowClass

A stylesheet class assigned to each label/field pair.

=head4 hoverHelp

A text string that will pop up when the user hovers over the label when toHtmlWithWrapper() is called. This string should indicate how to use the field and is usually tied into the help system.

=cut

sub definition {
	my $class = shift;
	my $session = shift;
	my $definition = shift || [];
	push(@{$definition}, {
		name=>{
			defaultValue=>undef
			},
		value=>{
			defaultValue=>undef
			},
		extras=>{
			defaultValue=>undef
			},
		defaultValue=>{
			defaultValue=>undef
			},
		_defaulted=>{
			defaultValue=>0
			},
		label=>{
			defaultValue=>undef
			},
		uiLevel=>{
			defaultValue=>1
			},
		labelClass=>{
			defaultValue=>"formDescription"
			},
		fieldClass=>{
			defaultValue=>"tableData"
			},
		rowClass=>{
			defaultValue=>undef
			},
		hoverHelp=>{
			defaultValue=>undef
			},
		subtext=>{
			defaultValue=>undef
			},
		id=>{
			defaultValue=>undef
			},
		idPrefix=>{
			defaultValue=>undef
			},
        allowEmpty=>{
            defaultValue => 0,
        },
    });
	return $definition;
}

#-------------------------------------------------------------------

=head2 displayForm ( )

Depricated, see toHtml().

=cut

sub displayForm {
	my $self = shift;
	return $self->toHtml(@_);
}

#-------------------------------------------------------------------

=head2 displayFormWithWrapper ( )

Depricated, see toHtmlWithWrapper().

=cut

sub displayFormWithWrapper {
	my $self = shift;
    return $self->toHtmlWithWrapper(@_);
}

#-------------------------------------------------------------------

=head2 displayValue ( )

Depricated, see getValueAsHtml().

=cut

sub displayValue {
	my ($self) = @_;
	return $self->getValueAsHtml;
}

#-------------------------------------------------------------------

=head2 fixMacros ( string ) 

Returns the string having converted all macros in the string to HTML entities so that they won't be processed by the macro engine, but instead will be displayed.

=head3 string

The string to search for macros in.

=cut

sub fixMacros {
	my $self = shift;
    my $value = shift;
    $value =~ s/\^/\&\#94\;/g;
    return $value;
}

#-------------------------------------------------------------------

=head2 fixQuotes ( string )

Returns the string having replaced quotes with HTML entities. This is important so not to screw up HTML attributes which use quotes as delimiters.

=head3 string

The string to search for quotes in.

=cut

sub fixQuotes {
	my $self = shift;
        my $value = shift;
        $value =~ s/\"/\&quot\;/g;
        return $value;
}

#-------------------------------------------------------------------

=head2 fixSpecialCharacters ( string )

Returns a string having converted any characters that have special meaning in HTML to HTML entities. Currently the only character is ampersand.

=head3 string

The string to search for special characters in.

=cut

sub fixSpecialCharacters {
	my $self = shift;
        my $value = shift;
        $value =~ s/\&/\&amp\;/g;
        return $value;
}

#-------------------------------------------------------------------

=head2 fixTags ( string )

Returns a string having converted HTML tags into HTML entities. This is useful when you have HTML that you need to render inside of a <textarea> for instance.

=head3 string

The string to search for HTML tags in.

=cut

sub fixTags {
	my $self = shift;
        my $value = shift;
        $value =~ s/\</\&lt\;/g;
        $value =~ s/\>/\&gt\;/g;
        return $value;
}

#-------------------------------------------------------------------

=head2 generateIdParameter ( name )

A class method that returns a value to be used as the autogenerated ID for this field instance. Unless overriden, it simply returns the name with "_formId" appended to it.

=head3 name

The name of the field.

=cut

sub generateIdParameter {
	my $class = shift;
	my $name = shift;
	return $name."_formId"; 
}



#-------------------------------------------------------------------

=head2 get ( var )

Returns a property of this form object.

=head3 var

The variable name of the value to return.

=cut

sub get {
	my $self = shift;
	my $var = shift;
	return $self->{_params}{$var};
}

#-------------------------------------------------------------------

=head2  getDatabaseFieldType ( )

A class method that tells you what database field type this form field should be stored in. Defaults to "CHAR(255)".

=cut 

sub getDatabaseFieldType {
    return "CHAR(255)";
}


#-------------------------------------------------------------------

=head2 getName ( session )

Returns a human readable name for this form control type. You MUST override this method with your own when creating new form controls.

=cut

sub getName {
    return "Override Me";
}

#-------------------------------------------------------------------

=head2 getValue ( [ value ] )

Gets the value of this form field from the following sources in order: passed in value, form post/get value, definition value, definition default value.

=head3 value

An optional value to process, instead of POST input.

=cut

# Note: This method calls getValueFromPost to maintain backwards compatibility.
# getValueFromPost is deprecated, use getValue
sub getValue {
    my $self    = shift;
    my $value   = shift;
    return $value if defined $value;
    return $self->getValueFromPost;
}

#-------------------------------------------------------------------

=head2 getOriginalValue ( )

Returns the either the "value" or "defaultValue" passed in to the object in that order, and doesn't take into account form processing.

=cut

sub getOriginalValue {
    my $self = shift;
    my $value = $self->get('value');
    return $value if (defined $value);  ##Handle returning 0 and empty string
    return $self->getDefaultValue;
}

#-------------------------------------------------------------------

=head2 getDefaultValue ( )

Returns the "defaultValue".

=cut

sub getDefaultValue {
    my $self = shift;
	return $self->get("defaultValue");
}


#-------------------------------------------------------------------

=head2 getValueAsHtml ( )

Returns the value rendered suitably in HTML. This is useful for forms that are rendered dynamically like user profiling and Thingy.

=cut

sub getValueAsHtml {
    my $self = shift;
    return $self->getOriginalValue(@_);
}

#-------------------------------------------------------------------

=head2 getValueFromPost

Depricated. See getValue().

=cut

# Note: This method does the actual work of getValue for backwards compatibility
# getValueFromPost is deprecated, use getValue
sub getValueFromPost {
    my $self    = shift;
    my $value = $self->session->form->param($self->get("name"));
    return $value if (defined $value);
    return $self->getDefaultValue;
}

#-------------------------------------------------------------------

=head2 isDynamicCompatible ( )

A class method that returns a boolean indicating whether this control is compatible with the DynamicField control. Returns 0.

=cut

sub isDynamicCompatible {
    return 0;
}

#-------------------------------------------------------------------

=head2 isInRequest ( )

Object method that returns true if the form variables for this control exist in the
posted data from the client.  This is required for all controls that are dynamic
compatible (->isDynamicCompatible=1).  It should be overridden by any class that
changes the name of the form variable, or uses more than 1 named element per form.

This method should only depend on the form name, and not secondary form properties
such as value, defaultValue or storage or asset id's.

=cut

sub isInRequest {
    my $self = shift;
    return $self->session->form->hasParam($self->get('name'));
}

#-------------------------------------------------------------------

=head2 isProfileEnabled ( session )

Depricated. See isDynamicCompatible().

=cut


sub isProfileEnabled {
    my $class = shift;
    return $class->isDynamicCompatible();
}


#-------------------------------------------------------------------

=head2 new ( session, parameters )

Constructor. Creates a new form field object.

=head3 session

A reference to the current session.

=head3 parameters

Accepts any parameters specified by the definition() method. This parameter set can be specified by either a hash or hash reference, and can be tagged or not. Here are examples:

 my $obj = $class->new($session, { name=>"this", value=>"that"});
 my $obj = $class->new($session, { -name=>"this", -value=>"that"});
 my $obj = $class->new($session, name=>"this", value=>"that");
 my $obj = $class->new($session, -name=>"this", -value=>"that");

Please note that an id attribute is automatically added to every form element with a name of name_formId. So if your form element has a name of "description" then the id attribute assigned to it would be "description_formId".

=cut

sub new {
	my $class = shift;
	my $session = shift;
	my %raw;
	# deal with a hash reference full of properties
	if (ref $_[0] eq "HASH") {
		%raw = %{$_[0]};
	} else {
		%raw = @_;
	}
	my %params;
	foreach my $definition (reverse @{$class->definition($session)}) {
		foreach my $fieldName (keys %{$definition}) {
			my $value = $raw{$fieldName};
			# if we have no value, try the tagged name
			unless (defined $value) {
				$value = $raw{"-".$fieldName};
			}
			# if we still have no value try the default value for the field
			unless (defined $value) {
				$value = $definition->{$fieldName}{defaultValue};
			}
			# and finally, if we have a value, let's set it
			if (defined $value) {
				$params{$fieldName} = $value;
			}
		}
	}
	# if the value field is undefined, lets use the defaultValue field instead
	# the _defaulted field is used to tell form fields that support noDate/noValue
	# options whether the field can be safely cleared or not.
	unless (exists $params{value}) {
		$params{value} = $params{defaultValue};
		$params{_defaulted} = 1;
	}
	# doesn't have an id specified, so let's give it one
	unless ($params{id}) {
		$params{id} = $class->generateIdParameter($params{name});
	}
	# preventing ID collisions
	$params{id} = $params{idPrefix}.$params{id};
	bless {_session=>$session, _params=>\%params}, $class;
}


#-------------------------------------------------------------------

=head2 passUiLevelCheck ( )

Renders the form field to HTML as a table row complete with labels, subtext, hoverhelp, etc.

=cut

sub passUiLevelCheck {
	my $self = shift;
	my $user = $self->session->user;
	return $self->get("uiLevel") <= $user->profileField("uiLevel") || $user->isAdmin;
}


#-------------------------------------------------------------------

=head2 prepareWrapper ( )

Common code for preparing wrappers for *WithWrapper

=cut

sub prepareWrapper {
	my $self = shift;
	my $rowClass = $self->get("rowClass");
	$rowClass = qq| class="$rowClass" | if($self->get("rowClass"));
	my $labelClass = $self->get("labelClass");
	$labelClass = qq| class="$labelClass" | if($self->get("labelClass"));
	my $fieldClass = $self->get("fieldClass");
	$fieldClass = qq| class="$fieldClass" | if($self->get("fieldClass"));
	my $hoverHelp = $self->get("hoverHelp") || '';
	$hoverHelp =~ s/^\s+//;
    my $subtext = $self->get("subtext");
	$subtext = qq| <span class="formSubtext">$subtext</span>| if ($subtext);
	return ($fieldClass, $rowClass, $labelClass, $hoverHelp, $subtext);
}


#-------------------------------------------------------------------

=head2 privateName ( )

Creates a safe, private name for additional use in multi-part forms like File and Image.

=cut

sub privateName {
	my ($self, $action) = @_;
	return join '_', '_', $self->get('name'), $action;
}

#-------------------------------------------------------------------

=head2 session ( )

Returns a reference to the current session.

=cut

sub session {
	my $self = shift;
	return $self->{_session};
}


#-------------------------------------------------------------------

=head2 set ( key, var )

Set a property of this form object.

=head3 key

The name of the property to set.

=head3 var

The value to set the property to.

=cut

sub set {
	my $self = shift;
	my $key = shift;
	my $value = shift;
	$self->{_params}{$key} = $value;
}

#-------------------------------------------------------------------

=head2 toHtml ( )

Renders the form field to HTML. This method should be overridden by all subclasses.

=cut

sub toHtml {
	my $self = shift;
    return $self->getOriginalValue();
}

#-------------------------------------------------------------------

=head2 toHtmlAsHidden ( )

Renders the form field to HTML as a hidden field rather than whatever field type it was supposed to be.

=cut

sub toHtmlAsHidden {
	my $self = shift;
        return '<input type="hidden" name="'.$self->get("name").'" value="'.
            $self->fixQuotes($self->fixMacros($self->fixSpecialCharacters(scalar $self->getOriginalValue()))).'" />'."\n";
}

#-------------------------------------------------------------------

=head2 toHtmlWithWrapper ( )

Renders the form field to HTML as a table row complete with labels, subtext, hoverhelp, etc.

=cut

sub toHtmlWithWrapper {
	my $self = shift;
	if ($self->passUiLevelCheck) {
		my $rawField = $self->toHtml(); # has to be called before prepareWrapper for some controls, namely captcha.
		my ($fieldClass, $rowClass, $labelClass, $hoverHelp, $subtext)  = $self->prepareWrapper;
        $hoverHelp &&= '<div class="wg-hoverhelp">' . $hoverHelp . '</div>';
        return '<tr'.$rowClass.' id="'.$self->get("id").'_row">
				<td'.$labelClass.' valign="top" style="width: 180px;"><label for="'.$self->get("id").'">'.$self->get("label").'</label>' . $hoverHelp . '</td>
				<td valign="top"'.$fieldClass.'>'.$rawField . $subtext . "</td>
			</tr>\n";
	} else {
		return $self->toHtmlAsHidden;
	}
}



1;

