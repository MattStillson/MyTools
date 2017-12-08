import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { Securing70744Component } from './securing70744.component';

describe('Securing70744Component', () => {
  let component: Securing70744Component;
  let fixture: ComponentFixture<Securing70744Component>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ Securing70744Component ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(Securing70744Component);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
