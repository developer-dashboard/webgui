package WebGUI::Wobject::WobjectProxy;

#-------------------------------------------------------------------
# WebGUI is Copyright 2001-2002 Plain Black LLC.
#-------------------------------------------------------------------
# Please read the legal notices (docs/legal.txt) and the license
# (docs/license.txt) that came with this distribution before using
# this software.
#-------------------------------------------------------------------
# http://www.plainblack.com                     info@plainblack.com
#-------------------------------------------------------------------

use strict;
use Tie::CPHash;
use WebGUI::DateTime;
use WebGUI::HTMLForm;
use WebGUI::Icon;
use WebGUI::International;
use WebGUI::Privilege;
use WebGUI::Session;
use WebGUI::SQL;
use WebGUI::Wobject;

our @ISA = qw(WebGUI::Wobject);
our $namespace = "WobjectProxy";
our $name = WebGUI::International::get(3,$namespace);


#-------------------------------------------------------------------
sub duplicate {
        my ($w);
	$w = $_[0]->SUPER::duplicate($_[1]);
        $w = WebGUI::Wobject::WobjectProxy->new({wobjectId=>$w,namespace=>$namespace});
        $w->set({
		proxiedWobjectId=>$_[0]->get("proxiedWobjectId")
		});
}

#-------------------------------------------------------------------
sub set {
        $_[0]->SUPER::set($_[1],[qw(proxiedWobjectId)]);
}

#-------------------------------------------------------------------
sub www_edit {
        my ($output, $f, $startDate, $endDate, $templatePosition,%wobjects, %page, %wobject, $a, $b);
	tie %wobject, 'Tie::CPHash';
	tie %page, 'Tie::CPHash';
	tie %wobjects, 'Tie::IxHash';
        if (WebGUI::Privilege::canEditPage()) {
                $output = helpIcon(1,$namespace);
		$output .= '<h1>'.WebGUI::International::get(2,$namespace).'</h1>';
		$templatePosition = $_[0]->get("templatePosition") || '0';
        	$startDate = $_[0]->get("startDate") || $session{page}{startDate};
        	$endDate = $_[0]->get("endDate") || $session{page}{endDate};
        	$f = WebGUI::HTMLForm->new;
        	$f->hidden("wid",$_[0]->get("wobjectId"));
        	$f->hidden("namespace",$_[0]->get("namespace")) if ($_[0]->get("wobjectId") eq "new");
        	$f->hidden("func","editSave");
        	$f->readOnly($_[0]->get("wobjectId"),WebGUI::International::get(499));
        	$f->hidden("title",$namespace);
        	$f->hidden("displayTitle",0);
        	$f->hidden("processMacros",0);
        	$f->select("templatePosition",WebGUI::Template::getPositions($session{page}{templateId}),WebGUI::International::get(363),[$templatePosition]);
        	$f->date("startDate",WebGUI::International::get(497),$startDate);
        	$f->date("endDate",WebGUI::International::get(498),$endDate);
		$a = WebGUI::SQL->read("select pageId,menuTitle from page where pageId<2 or pageId>25 order by title");
		while (%page = $a->hash) {
			$b = WebGUI::SQL->read("select wobjectId,title from wobject where pageId=".$page{pageId}." and namespace<>'WobjectProxy' order by sequenceNumber");
			while (%wobject = $b->hash) {
				$wobjects{$wobject{wobjectId}} = $page{menuTitle}." / ".$wobject{title}." (".$wobject{wobjectId}.")";
			}
			$b->finish;
		}
		$a->finish;
		$f->select("proxiedWobjectId",\%wobjects,WebGUI::International::get(1,$namespace),[$_[0]->get("proxiedWobjectId")]);
        	$f->submit;
        	$output .= $f->print;
		return $output;
        } else {
                return WebGUI::Privilege::insufficient();
        }
}

#-------------------------------------------------------------------
sub www_editSave {
        if (WebGUI::Privilege::canEditPage()) {
		$_[0]->SUPER::www_editSave();
                $_[0]->set({
			proxiedWobjectId=>$session{form}{proxiedWobjectId}
			});
                return "";
        } else {
                return WebGUI::Privilege::insufficient();
        }
}

#-------------------------------------------------------------------
sub www_view {
	return	WebGUI::International::get(4,$namespace);
}


1;

